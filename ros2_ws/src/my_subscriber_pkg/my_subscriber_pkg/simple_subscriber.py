import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class SimpleSubscriber(Node):

    def __init__(self):
        super().__init__('simple_subscriber')
        self.subscription = self.create_subscription(
            String,           # 메시지 타입
            'greetings',      # 토픽 이름 (퍼블리셔와 동일해야 함)
            self.listener_callback,  # 콜백 함수
            10                # 큐 사이즈
        )
        self.subscription  # 방지용 (linter warning)

    def listener_callback(self, msg):
        self.get_logger().info(f'Received message: "{msg.data}"')

def main(args=None):
    rclpy.init(args=args)
    node = SimpleSubscriber()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
