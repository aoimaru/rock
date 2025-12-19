# AMIの取得
data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# 既に作成済みのリソース読み込み
## VPCの取り込み
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${var.project}-${var.environment}"]
  }
}
## サブネットの取り込み
data "aws_subnet" "private_subnet_1a" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-subnet-1a"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_subnet" "private_subnet_1c" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-subnet-1c"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_subnet" "public_subnet_1a" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-public-subnet-1a"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_subnet" "public_subnet_1c" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-public-subnet-1c"]
  }
  vpc_id = data.aws_vpc.selected.id
}

#　ルートテーブルの取り込み: NATゲートウェイ作成で利用
data "aws_route_table" "private_rt" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-rt"]
  }
  vpc_id = data.aws_vpc.selected.id
}

## セキュリティグループの取り込み
data "aws_security_group" "app_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-app-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_security_group" "opmng_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-opmng-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_security_group" "ssm_endpoint_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-ssm-endpoint-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}

# IAMロールの取り込み
## SSM接続用のIAMロール
data "aws_iam_role" "ssm_instance_role" {
  name = "${var.project}-${var.environment}-${var.ver}-ssm-role"
}
## SSM接続用のインスタンスプロファイルの取り込み
data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.project}-${var.environment}-${var.ver}-ssm-instance-profile"
}
## アプリケーション用のIAMロール
data "aws_iam_role" "app_instance_role" {
  name = "${var.project}-${var.environment}-${var.ver}-app-role"
}
## アプリケーション用のインスタンスプロファイルの取り込み
data "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.project}-${var.environment}-${var.ver}-app-instance-profile"
}