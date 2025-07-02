<a target="_blank" href="https://colab.research.google.com/github/eatcosmos/mcp-frp/blob/master/mcp-frp.ipynb">
  <img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab"/>
</a>

## 操作步骤
- 新注册一个Goole账号，淘宝买一个PRO
- 购买一个阿里云99之类的服务器或者淘宝买个用于frps服务器，下载本仓库 git clone https://github.com/eatcosmos/mcp-frp /home/ubuntu/code/mcp-frp
  - 修改frps.toml的bindPort和webServer.port为7001和7501，然后运行 ./run-frps.sh 启动frps服务 
  - 记得服务器防火墙开放frps绑定端口和映射端口
  - 在Colab配置Secret/密钥，名称FRPS_SERVER_IP，值为frps服务器的公网IP
- 生成 id_rsa.pub id_rsa 文件，id_rsa.pub后面用于替换  /content/drive/MyDrive/code/mcp-frp/id_rsa.pub
- 打开顶部的Colab链接，也就是本仓库的mcp-frp.ipynb，按步骤运行单元格即可
- 最后在Cursor里面配置SSH连接 C:\\Users\用户名\\.ssh\\config

```
Host ubuntu-colab-1
  HostName 服务器公网IP
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  Port 7502
  User root
  ForwardAgent yes
  PubKeyAuthentication yes                   
  IdentityFile ~/.ssh/id_rsa
```

