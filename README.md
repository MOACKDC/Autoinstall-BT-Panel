# Autoinstall-BT-Panel
centos自动安装宝塔面板并推送到telegram机器人<br>
通过解析宝塔面板安装时输出信息,获取登录信息等其他信息并推送到tg机器人<br>
完成安装后自动删除此脚本<br>
适用于大量安装时,同时将脚本推送到所有服务器上,并在telegram上获取登录信息<br>

```shell
wget https://raw.githubusercontent.com/MOACKDC/Autoinstall-BT-Panel/main/install_baota_send_to_TG.sh
```
修改telegram的api和群组id

```shell
chmod +x install_baota_send_to_TG.sh
sh install_baota_send_to_TG.sh
```
