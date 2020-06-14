provider "aws"{
    region = "ap-south-1"
    profile = "saurabh"
}

resource "aws_key_pair" "mykey"{
    key_name = "testKey"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA4o7H0VwV+jp/H5adq382/KiewNzigEqKlMKwGUEMwSLzJE5LeiqwoNLj+BtW+47Jwv6i7S3KNft0EuWn0rZrYPEToW7wN3j4vEyZllWZzl0lflPJ6hroLDMa8YRs3CM2SgBJQgBRgSlaz60NNKC20CnSOY+hc2D/7HhsG4UF9O16urlludkZu2JEZ5rFf3GxrscyzoGlL8pRiZJTFgAIg4dXYXNTJ8XSsa20RgVa+DFeRpYAysv8Hio/RH5louCU+GBjhxeDO/lUZqcUDQkGG8RSo5oJwOrOOacPDfrT5Y+j8OnC4PJmxBYHejHFrCeUGJXm6VZXBDlJL58gm9vSEw== dimrisaurabh06@gmail.com"
}