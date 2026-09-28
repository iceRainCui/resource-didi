#!/bin/bash
DIR="/Users/didi/Documents/串讲/ppt/resource-didi/灵历集光_音频"
LOG="$DIR/generation_log.txt"
echo "========== 开始 ==========" >> "$LOG"
echo "时间: $(date)" >> "$LOG"

for i in $(seq -f "%03g" 2 70); do
    TXT="$DIR/chunk_${i}.txt"
    M4A="$DIR/chunk_${i}.m4a"
    
    if [ -f "$M4A" ]; then
        echo "[$i/70] 跳过(已存在)" >> "$LOG"
        continue
    fi
    
    if [ ! -f "$TXT" ]; then
        echo "[$i/70] ❌ 文件不存在 $TXT" >> "$LOG"
        continue
    fi
    
    CHARS=$(wc -c < "$TXT" | tr -d ' ')
    echo -n "[$i/70] $(date '+%H:%M:%S') ${CHARS}字符 → " >> "$LOG"
    
    cat "$TXT" | say -v Tingting -r 220 -o "$DIR/chunk_${i}.aiff" 2>/dev/null
    afconvert -f m4af -d aac -q 64 "$DIR/chunk_${i}.aiff" -o "$M4A" 2>/dev/null
    rm "$DIR/chunk_${i}.aiff"
    
    SIZE=$(du -h "$M4A" | cut -f1)
    echo "✅ $SIZE" >> "$LOG"
done

echo "========== 完成 $(date) ==========" >> "$LOG"
echo "总计M4A: $(ls "$DIR"/*.m4a 2>/dev/null | wc -l)/70" >> "$LOG"
