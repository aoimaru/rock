## NATゲートウェイに関する設定
# terraform destroy する前に…
# terraform state rm aws_route.nat_gateway_route　を実行してからdestroyすること
# ↑ これをしないと、NATゲートウェイを削除できないため

# NAT用のEIPを作成
resource "aws_eip" "nat" {
  domain = "vpc"
}
# ↑ 確かこの固定IPにお金がかかっていたはず

# NATゲートウェイの作成
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  # NATゲートウェイはパブリックサブネットに配置する必要がある
  subnet_id = data.aws_subnet.public_subnet_1a.id
  tags = {
    Name = "${var.project}-${var.environment}-${var.ver}-nat-gateway"
  }
}

resource "aws_route" "nat_gateway_route" {
  # private用のルートテーブルに来た通信で
  route_table_id = data.aws_route_table.private_rt.id
  # 外向きの全ての通信をNATゲートウェイに送る
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
