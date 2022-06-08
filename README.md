# peoplenet-on-tao-toolkit
peoplenet-on-tao-toolkit は、NVIDIA TAO TOOLKIT を用いて PeopleNet の AIモデル最適化を行うマイクロサービスです。  

## 動作環境
- NVIDIA 
    - TAO TOOLKIT
- PeopleNet
- Docker
- TensorRT Runtime

## PeopleNetについて
PeopleNet は、画像内の人を検出し、カテゴリラベルを返すAIモデルです。  
PeopleNet は、特徴抽出にResNet34を使用しており、混雑した場所でも正確に物体検出を行うことができます。

## 動作手順

### engineファイルの生成
PeopleNet のAIモデルをデバイスに最適化するため、ResNet34 における PeopleNet の .etlt ファイルを engine file に変換します。  
現時点におけるNVIDIAの仕様では、GPUのアーキテクチャごとに engine file の生成が必要です。  
つまり、あるサーバで生成した engine file を別のサーバーにそのまま適用することはできません。  
本レポジトリに格納された peoplenet.engine は、実際に生成される engine file の参考例です。  
engine fileへの変換は、Makefile に記載された以下のコマンドにより実行できます。

```
tao-convert:
	docker exec -it tao-tool-kit tao-converter -k tlt_encode -d 3,544,960 -e /app/src/saved.engine /app/src/resnet34_peoplenet_pruned.etlt 
```

## 相互依存関係にあるマイクロサービス  
本マイクロサービスで最適化された PeopleNet の AIモデルを Deep Stream 上で動作させる手順は、[peoplenet-on-deepstream](https://github.com/latonaio/peoplenet-on-deepstream)を参照してください。  

## engineファイルについて
engineファイルである peoplenet.engine は、[peoplenet-on-deepstream](https://github.com/latonaio/peoplenet-on-deepstream)と共通のファイルであり、本レポジトリで作成した engineファイルを、当該リポジトリで使用しています。  
