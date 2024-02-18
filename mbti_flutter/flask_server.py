from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/process_text', methods=['POST'])
def process_text():
    data = request.form
    text = data['question']

    # 여기서는 받은 텍스트를 모델에 입력하여 처리하고, 결과를 반환합니다.
    # 실제로는 모델을 호출하여 처리하게 됩니다.
    # 여기서는 간단히 입력된 텍스트를 대문자로 변환하여 반환하는 예를 들었습니다.
    result = text.upper()

    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(debug=True)