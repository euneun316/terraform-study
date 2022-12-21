# bastion-sg
bastion_ingress_rules = [
  {
    from_port = "22",
    to_port   = "22",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "22",
    to_port   = "22",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "22",
    to_port   = "22",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  }
]

# ALB-service-sg
service_ingress_rules = [
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  },
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  },
  {
    from_port = "8085",
    to_port   = "8085",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "8085",
    to_port   = "8085",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "8085",
    to_port   = "8085",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  },
  {
    from_port = "8086",
    to_port   = "8086",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "8086",
    to_port   = "8086",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "8086",
    to_port   = "8086",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  }
]

# ALB-management-sg
management_ingress_rules = [
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  },
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  },
  {
    from_port = "8080",
    to_port   = "8080",
    cidr      = "18.164.239.93/32"
    desc      = "ImOK Tower wireless ip"
  },
  {
    from_port = "8080",
    to_port   = "8080",
    cidr      = "111.245.120.118/32"
    desc      = "ImOK Tower lan"
  },
  {
    from_port = "8080",
    to_port   = "8080",
    cidr      = "179.245.107.211/32"
    desc      = "ImOK Corp VPN"
  }
]

# ACM
acm_certi = "arn:aws:acm:ap-northeast-2:[Account ID]:certificate/0000"
