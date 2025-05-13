import pika

def callback(ch, method, properties, body):
    print("📩 Notification received:", body.decode())

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
channel.queue_declare(queue='default')  # Celery default queue

channel.basic_consume(queue='default', on_message_callback=callback, auto_ack=True)
print('[*] Waiting for messages.')
channel.start_consuming()
