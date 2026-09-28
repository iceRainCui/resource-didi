#!/bin/bash
# Auto-generated audio generation script
OUTPUT_DIR="/Users/didi/Documents/串讲/ppt/resource-didi/灵历集光_音频"
TOTAL=70

echo "开始生成音频，共 $TOTAL 个片段..."

for i in $(seq -w 1 $TOTAL); do
    CHUNK_FILE="$OUTPUT_DIR/chunk_${i}.txt"
    AIFF_FILE="$OUTPUT_DIR/chunk_${i}.aiff"
    M4A_FILE="$OUTPUT_DIR/chunk_${i}.m4a"
    
    if [ -f "$M4A_FILE" ]; then
        echo "[$i/$TOTAL] 已存在，跳过: chunk_${i}.m4a"
        continue
    fi
    
    if [ ! -f "$CHUNK_FILE" ]; then
        echo "[$i/$TOTAL] 文件不存在，跳过: $CHUNK_FILE"
        continue
    fi
    
    echo "[$i/$TOTAL] 正在生成音频: chunk_${i}..."
    
    # Read text and generate audio
    cat "$CHUNK_FILE" | say -v Tingting -r 220 -o "$AIFF_FILE" --progress 2>&1
    
    if [ -f "$AIFF_FILE" ]; then
        echo "[$i/$TOTAL] 正在压缩为 m4a..."
        afconvert -f m4af -d aac -q 64 "$AIFF_FILE" -o "$M4A_FILE" 2>/dev/null
        if [ -f "$M4A_FILE" ]; then
            rm "$AIFF_FILE"
            SIZE=$(du -h "$M4A_FILE" | cut -f1)
            echo "[$i/$TOTAL] 完成: chunk_${i}.m4a ($SIZE)"
        else
            echo "[$i/$TOTAL] 压缩失败，保留 aiff 文件"
        fi
    else
        echo "[$i/$TOTAL] 音频生成失败!"
    fi
done

echo "全部完成！"
echo "文件列表："
ls -lh "$OUTPUT_DIR"/*.m4a 2>/dev/null || ls -lh "$OUTPUT_DIR"/*.aiff 2>/dev/null
