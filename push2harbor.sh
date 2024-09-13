#!/bin/bash

# 设置Harbor仓库的地址和凭据

#harbor服务器地址
HARBOR_URL="rthl.88ic.cn:5005"

#用户名
HARBOR_USERNAME="wangweipeng"

#登录密码
HARBOR_PASSWORD="com.bjhnxy"

#指定的harbor仓库名
HARBOR_PROJECT="706"

# 登录到Harbor仓库
docker login $HARBOR_URL -u $HARBOR_USERNAME -p $HARBOR_PASSWORD

# 获取服务器上的所有Docker镜像列表
images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep bitnami )

# 遍历每个镜像并上传到Harbor的m55all-images仓库
for image in $images; do
	# 提取镜像的仓库名称和标签
	repo=$(echo $image | cut -d':' -f1)
	tag=$(echo $image | cut -d':' -f2)

	# 构建Harbor仓库中的镜像引用
	harbor_image="$HARBOR_URL/$HARBOR_PROJECT/$repo:$tag"

	# 重新标记镜像，将其命名为Harbor仓库的地址
	docker tag $image $harbor_image

	# 上传镜像到Harbor
	docker push $harbor_image

	echo "镜像 $image 上传至Harbor $HARBOR_PROJECT 仓库成功！"
done

echo "所有Docker镜像上传至Harbor $HARBOR_PROJECT 仓库完成。"
