import logging
import pika

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def callback(ch, method, properties, body):
    logging.info("📩 Notification received: %s", body.decode())

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
channel.queue_declare(queue='default')  # Celery default queue

channel.basic_consume(queue='default', on_message_callback=callback, auto_ack=True)
logging.info('[*] Waiting for messages.')
channel.start_consuming()
