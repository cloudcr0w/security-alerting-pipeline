from flask import Flask, request

app = Flask(__name__)

@app.route("/alert", methods=["POST"])
def receive_alert():
    data = request.get_json()
    print("Received alert:")
    print(data)
    return {"message": "Alert received"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

@app.route("/version", methods=["GET"])
def version():
    return {"version": "1.0.0"}, 200
