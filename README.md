# GAN Homework: edges2shoes pix2pix

本仓库是一次基于 GAN 的图像到图像翻译作业实现，任务为：

> 输入鞋子的边缘图，生成对应的鞋子照片。

该任务使用 `edges2shoes` 成对数据集，模型采用 pix2pix，是 conditional GAN。属于有监督的 image-to-image translation。

## 目录说明

```text
.
├── train.py / test.py              # 原 pix2pix 训练与推理入口
├── data/ models/ options/ util/    # 核心模型与数据加载代码
├── datasets/                       # 数据集下载脚本，不包含完整数据集
├── scripts/
│   ├── download_edges2shoes.sh     # 下载 edges2shoes 数据集
│   ├── train_edges2shoes_full.sh   # 训练脚本
│   ├── infer_edges2shoes.sh        # 推理脚本
│   └── reconstruct_model.sh        # 合并模型分片
└── checkpoints/edges2shoes_pix2pix_full_bs4/
    ├── latest_net_G.pth.part-*     # 已训练生成器模型分片
    ├── train_opt.txt               # 本次训练参数
    └── loss_log.txt                # 本次训练日志
```


## 环境配置

使用 conda 环境，原项目环境文件已保留：

```bash
conda env create -f environment.yml
conda activate pytorch-img2img
```

## 下载数据集

```bash
bash scripts/download_edges2shoes.sh
```

下载后默认数据路径为：

```text
datasets/edges2shoes
```

如果是已有数据集路径：

```text
/workspace/network/homework3/data/edges2shoes
```

## 使用已训练模型推理

仓库中包含已训练生成器模型，但由于 GitHub 普通文件大小限制，`latest_net_G.pth` 被拆成了多个分片。推理脚本会自动合并模型分片。

使用默认数据路径：

```bash
bash scripts/infer_edges2shoes.sh
```

使用自定义数据路径：

```bash
bash scripts/infer_edges2shoes.sh /workspace/network/homework3/data/edges2shoes
```

推理结果保存到：

```text
results/edges2shoes_pix2pix_full_bs4/val_latest/index.html
```

如果只想手动恢复模型：

```bash
bash scripts/reconstruct_model.sh
```

恢复后模型路径为：

```text
checkpoints/edges2shoes_pix2pix_full_bs4/latest_net_G.pth
```

## 训练模型

使用默认数据路径：

```bash
bash scripts/train_edges2shoes_full.sh
```

使用自定义数据路径：

```bash
bash scripts/train_edges2shoes_full.sh /workspace/network/homework3/data/edges2shoes
```

本次训练命令相当于：

```bash
python train.py \
  --dataroot datasets/edges2shoes \
  --name edges2shoes_pix2pix_full_bs4 \
  --model pix2pix \
  --direction AtoB \
  --n_epochs 5 \
  --n_epochs_decay 0 \
  --batch_size 4 \
  --lr 0.0002 \
  --num_threads 4 \
  --print_freq 500 \
  --save_latest_freq 5000 \
  --save_epoch_freq 5
```

其中 `AtoB` 表示从输入边缘图生成鞋子照片。`edges2shoes` 的拼接图片左半边是 edge，右半边是 shoe photo。

训练配置：

- 模型：pix2pix
- 数据：edges2shoes
- 方向：AtoB
- epoch：5
- batch size：4
- learning rate：0.0002
- 生成器：U-Net 256
- 判别器：PatchGAN basic

训练日志位于：

```text
checkpoints/edges2shoes_pix2pix_full_bs4/loss_log.txt
```

训练参数位于：

```text
checkpoints/edges2shoes_pix2pix_full_bs4/train_opt.txt
```

## 来源说明

核心实现基于：

```text
https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix
```

本仓库保留了原项目 LICENSE，并添加了本次 edges2shoes 作业的训练脚本、推理脚本和已训练模型分片。
