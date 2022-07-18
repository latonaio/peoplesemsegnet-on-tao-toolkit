# peoplesemsegnet-on-tao-toolkit
peoplesemsegnet-on-tao-toolkit は、NVIDIA TAO TOOLKIT を用いて PeopleSemSegNet の AIモデル最適化を行うマイクロサービスです。  

## 動作環境
- NVIDIA 
    - TAO TOOLKIT
- PeopleSemSegNet
- Docker
- TensorRT Runtime

## PeopleSemSegNetについて
PeopleSemSegNet は、画像内の人を背景から分離するセマンティックセグメンテーションマスクを返すAIモデルです。  
PeopleSemSegNet は、特徴抽出にUNetを使用しています。  

## 動作手順

### engineファイルの生成
PeopleSemSegNet のAIモデルをデバイスに最適化するため、PeopleSemSegNet の .etlt ファイルを engine file に変換します。  
現時点におけるNVIDIAの仕様では、GPUのアーキテクチャごとに engine file の生成が必要です。  
つまり、あるサーバで生成した engine file を別のサーバーにそのまま適用することはできません。  
本レポジトリに格納された peoplesemsegnet.etlt_b1_gpu0_fp16.engine は、実際に生成される engine file の参考例です。  
engine fileへの変換は、Makefile に記載された以下のコマンドにより実行できます。

```
tao-convert:
	docker exec -it peoplesemsegnet-tao-toolkit tao-converter -k tlt_encode -t fp16 \
		-p input_1,1x3x544x960,1x3x544x960,1x3x544x960 -e /app/src/peoplesemsegnet.etlt_b1_gpu0_fp16.engine /app/src/peoplesemsegnet.etlt

```

## 相互依存関係にあるマイクロサービス  
本マイクロサービスで最適化された PeopleSemSegNet の AIモデルを Deep Stream 上で動作させる手順は、[peoplesemsegnet-on-deepstream](https://github.com/latonaio/peoplesemsegnet-on-deepstream)を参照してください。  

## engineファイルについて
engineファイルである peoplesemsegnet.etlt_b1_gpu0_fp16.engine は、[peoplesemsegnet-on-deepstream](https://github.com/latonaio/peoplesemsegnet-on-deepstream)と共通のファイルであり、本レポジトリで作成した engineファイルを、当該リポジトリで使用しています。  

## 演算について
本レポジトリでは、ニューラルネットワークのモデルにおいて、エッジコンピューティング環境での演算スループット効率を高めるため、FP16(半精度浮動小数点)を使用しています。  
浮動小数点値の変更は、Makefileの以下の部分を変更し、engineファイルを生成してください。

```
tao-convert:
	docker exec -it peoplesemsegnet-tao-toolkit tao-converter -k tlt_encode -t fp16 \
		-p input_1,1x3x544x960,1x3x544x960,1x3x544x960 -e /app/src/peoplesemsegnet.etlt_b1_gpu0_fp16.engine /app/src/peoplesemsegnet.etlt

```