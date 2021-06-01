# executed on EC2 Instance
# - Amazon マシンイメージ (AMI): Amazon Linux 2 AMI (HVM), SSD Volume Type, 64 ビット (x86)
# - インスタンスタイプの選択: t2.xlarge
# - IAMロール: 既存のもの（S3 バケットへのアクセス）
# - シャットダウン動作: 終了
# - タグの追加: build_lambda_layer_python_tflite_runtime (適当な文字列)
# - キーペアの選択: 既存のもの

sudo yum install -y git docker
sudo usermod -a -G docker ec2-user

cd
git clone https://github.com/tpaul1611/python_tflite_for_amazonlinux
cd python_tflite_for_amazonlinux
git checkout -b temp 415ec188df3862514a0cd9a088a6d639201ba78b

sudo service docker start
sudo docker build -t tflite_amazonlinux .
sudo docker run -d --name=tflite_amazonlinux tflite_amazonlinux
sudo docker cp tflite_amazonlinux:/usr/local/lib64/python3.7/site-packages .
sudo docker stop tflite_amazonlinux

mkdir -p ./python/lib/python3.7
mv site-packages ./python/lib/python3.7
zip -r layer.zip python/  

# S3に出力する場合
# aws s3 cp layer.zip s3://mybucketname/

sudo shutdown now