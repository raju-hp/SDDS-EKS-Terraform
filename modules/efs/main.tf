resource "aws_security_group" "efs" {
  name        = "${var.name}-sg"
  description = "Allow NFS from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS from EKS nodes"
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = var.allowed_sg_ids
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg"
  })
}

resource "aws_efs_file_system" "this" {
  creation_token  = var.name
  encrypted       = true
  throughput_mode = var.throughput_mode

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "sdds" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/sdds"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0755"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sdds-ap"
  })
}
