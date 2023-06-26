# !/bin/bash


# root=https://api.ngc.nvidia.com/v2/models/nvidia/research/stylegan3/versions/1/files
models3=(stylegan3-t-ffhq-1024x1024.pkl stylegan3-t-ffhqu-1024x1024.pkl stylegan3-t-ffhqu-256x256.pkl stylegan3-r-ffhq-1024x1024.pkl stylegan3-r-ffhqu-1024x1024.pkl stylegan3-r-ffhqu-256x256.pkl stylegan3-t-metfaces-1024x1024.pkl stylegan3-t-metfacesu-1024x1024.pkl stylegan3-r-metfaces-1024x1024.pkl stylegan3-r-metfacesu-1024x1024.pkl stylegan3-t-afhqv2-512x512.pkl stylegan3-r-afhqv2-512x512.pkl )

# for model in "${models3[@]}"; do
#    if [ ! -f $model ]; then
#        wget "${root}/${model}"
#    fi
# done

# root2=https://api.ngc.nvidia.com/v2/models/nvidia/research/stylegan2/versions/1/files
models2=(stylegan2-ffhq-1024x1024.pkl stylegan2-ffhq-512x512.pkl stylegan2-ffhq-256x256.pkl stylegan2-ffhqu-1024x1024.pkl stylegan2-ffhqu-256x256.pkl stylegan2-metfaces-1024x1024.pkl stylegan2-metfacesu-1024x1024.pkl stylegan2-afhqv2-512x512.pkl stylegan2-afhqcat-512x512.pkl stylegan2-afhqdog-512x512.pkl stylegan2-afhqwild-512x512.pkl stylegan2-brecahad-512x512.pkl stylegan2-cifar10-32x32.pkl stylegan2-celebahq-256x256.pkl stylegan2-lsundog-256x256.pkl)
# for model in "${models2[@]}"; do 
#     if [ ! -f $model ]; then
#         wget "${root2}/${model}"
#     fi
# done

for model in "${models3[@]}"; do
    python gen_images.py --outdir=out --trunc=1 --seeds=0,4,1000,65536,262144 --network=$model
done

for model in "${models2[@]}"; do
    python gen_images.py --outdir=out --trunc=1 --seeds=0,4,1000,65536,262144 --network=$model
done