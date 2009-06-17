require 'drb'

DRb.start_service
server = DRbObject.new_with_uri('druby://localhost:4242')
p server.incremnet
p server.incremnet

