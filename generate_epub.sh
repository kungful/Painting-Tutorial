#!/bin/bash

# 检查pandoc是否安装
if ! command -v pandoc &> /dev/null
then
    echo "pandoc 未安装。请安装 pandoc 以生成 EPUB 文件。"
    echo "在 Debian/Ubuntu 上，可以使用 'sudo apt install pandoc'"
    echo "在 macOS 上，可以使用 'brew install pandoc'"
    echo "在 Windows 上，请访问 https://pandoc.org/installing.html 下载安装程序。"
    exit 1
fi

# 定义书籍的标题和作者
BOOK_TITLE="美术绘画教程"
BOOK_AUTHOR="hua"
OUTPUT_FILE="美术绘画教程.epub"

# 定义章节文件的顺序
CHAPTER_FILES=(
    "main.md"
    "引言_绘画的乐趣与基础.md"
    "第一章_剪影观察与整体性.md"
    "第二章_素描基础.md"
    "第三章_色彩理论与应用.md"
    "第四章_构图与透视.md"
    "第五章_人体结构与动态.md"
    "第六章_风景画技巧.md"
    "第七章_静物画技巧.md"
    "第八章_数字绘画入门.md"
    "第九章_创作实践与风格探索.md"
    "第十章_想象力与创造力.md"
    "第十一章_如何应对AI绘画.md"
    "结语_持续学习与进步.md"
)

# 创建一个临时文件来合并所有章节
TEMP_FULL_BOOK="full_book.md"
> "$TEMP_FULL_BOOK" # 清空或创建文件

echo "正在合并章节文件..."
for file in "${CHAPTER_FILES[@]}"
do
    if [ -f "$file" ]; then
        cat "$file" >> "$TEMP_FULL_BOOK"
        echo -e "\n\n" >> "$TEMP_FULL_BOOK" # 在章节之间添加空行，确保内容分隔
    else
        echo "警告：文件 $file 不存在，将跳过。"
    fi
done

echo "正在生成 EPUB 文件：$OUTPUT_FILE"
# 使用 pandoc 将合并后的 Markdown 转换为 EPUB
# --toc：生成目录
# --metadata title="..." --metadata author="..."：设置书籍元数据
# -o：指定输出文件
pandoc "$TEMP_FULL_BOOK" \
       --toc \
       --metadata title="$BOOK_TITLE" \
       --metadata author="$BOOK_AUTHOR" \
       -o "$OUTPUT_FILE"

# 检查 pandoc 命令是否成功执行
if [ $? -eq 0 ]; then
    echo "EPUB 文件已成功生成：$OUTPUT_FILE"
else
    echo "EPUB 文件生成失败。"
fi

# 清理临时文件
rm "$TEMP_FULL_BOOK"
echo "临时文件 $TEMP_FULL_BOOK 已删除。"
