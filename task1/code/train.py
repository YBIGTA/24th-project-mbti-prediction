import os
import torch
import numpy as np
from torch.optim import AdamW
from sklearn.metrics import accuracy_score, precision_recall_fscore_support
from tqdm import tqdm
from transformers import BertForSequenceClassification

class Train:
    def __init__(self, train_dataloader, validation_dataloader, test_dataloader, label_encoder, args):
        self.model = BertForSequenceClassification.from_pretrained(
            "bert-base-uncased",
            num_labels=len(label_encoder.classes_),
            output_attentions=False,
            output_hidden_states=False,
        )
        self.train_dataloader = train_dataloader
        self.validation_dataloader = validation_dataloader
        self.test_dataloader = test_dataloader
        self.label_encoder = label_encoder
        self.args = args
    
    def train(self):
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.model.to(device)
        optimizer = AdamW(self.model.parameters(), lr=self.args.learning_rate, eps=1e-8)

        model_save_path = '../model'
        os.makedirs(model_save_path, exist_ok=True)
        
        best_accuracy = 0
        no_improve_epochs = 0
        early_stopping_patience = 3
        
        self.model.train()
        for epoch in range(self.args.epoch):
            print(f'Epoch {epoch+1}/{self.args.epoch}')
            print('-' * 10)

            train_loss = 0
            for batch in tqdm(self.train_dataloader, desc="Training"):
                batch = tuple(t.to(device) for t in batch)
                b_input_ids, b_input_mask, b_labels = batch

                self.model.zero_grad()
                outputs = self.model(b_input_ids, token_type_ids=None, attention_mask=b_input_mask, labels=b_labels.long())
                loss = outputs.loss
                train_loss += loss.item()
                loss.backward()

                optimizer.step()

            avg_loss = train_loss / len(self.train_dataloader)
            print(f'Training loss: {avg_loss}')

            accuracy, precision, recall, f1, dimension_accuracies = self.evaluate()
            print(f'Accuracy: {accuracy}')
            print(f'Precision: {precision}')
            print(f'Recall: {recall}')
            print(f'F1 Score: {f1}')

            for dim, acc in dimension_accuracies.items():
                print(f'{dim} Accuracy: {acc}')

            if accuracy > best_accuracy:
                best_accuracy = accuracy
                no_improve_epochs = 0
                torch.save(self.model.state_dict(), os.path.join(model_save_path, 'best_model.pth'))
                print("Improved validation accuracy. Model saved.")
            else:
                no_improve_epochs += 1
                print("No improvement in validation accuracy.")
                if no_improve_epochs >= early_stopping_patience:
                    print("Stopping early due to no improvement.")
                    break

    
    def evaluate(self):
        self.model.eval()
        predictions, true_labels = [], []

        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.model.to(device)

        for batch in tqdm(self.validation_dataloader, desc="Evaluating"):
            batch = tuple(t.to(device) for t in batch)
            b_input_ids, b_input_mask, b_labels = batch

            with torch.no_grad():
                outputs = self.model(b_input_ids, token_type_ids=None, attention_mask=b_input_mask)
            
            logits = outputs.logits
            logits = logits.detach().cpu().numpy()
            label_ids = b_labels.to('cpu').numpy()
            
            predictions.extend(np.argmax(logits, axis=1).flatten())
            true_labels.extend(label_ids.flatten())

        overall_accuracy = accuracy_score(true_labels, predictions)
        overall_precision, overall_recall, overall_f1, _ = precision_recall_fscore_support(true_labels, predictions, average='weighted')

        true_dimensions = self.extract_dimension_labels(true_labels)
        pred_dimensions = self.extract_dimension_labels(predictions)
        dimension_accuracies = {}
        for dimension, true_dim_labels in true_dimensions.items():
            dimension_accuracies[dimension] = accuracy_score(true_dim_labels, pred_dimensions[dimension])

        return overall_accuracy, overall_precision, overall_recall, overall_f1, dimension_accuracies


    def extract_dimension_labels(self, encoded_labels):
        decoded_labels = self.label_encoder.inverse_transform(encoded_labels)
        dimensions = {
            'EI': [1 if label[0] == 'E' else 0 for label in decoded_labels],
            'NS': [1 if label[1] == 'N' else 0 for label in decoded_labels],
            'FT': [1 if label[2] == 'F' else 0 for label in decoded_labels],
            'JP': [1 if label[3] == 'J' else 0 for label in decoded_labels]
        }
        return dimensions
    

    def run_test(self):
        best_model_path = os.path.join('../model', 'best_model.pth')
        self.model.load_state_dict(torch.load(best_model_path))

        test_accuracy, test_precision, test_recall, test_f1, dimension_accuracies = self.evaluate()

        print(f'Test Accuracy: {test_accuracy}')
        print(f'Test Precision: {test_precision}')
        print(f'Test Recall: {test_recall}')
        print(f'Test F1 Score: {test_f1}')
        print("MBTI Dimension Accuracies:")
        for dimension, accuracy in dimension_accuracies.items():
            print(f"{dimension} Accuracy: {accuracy}")