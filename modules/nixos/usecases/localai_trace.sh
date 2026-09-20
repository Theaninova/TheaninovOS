#!/usr/bin/env sh

mkdir -p "$TRACE_DIR"

if ! command -v "$BIN" >/dev/null 2>&1; then
  echo "[ERROR] missing binary $BIN"
  exit 1
fi

echo "[INFO] Using binary: $(command -v "$BIN")"
echo "[INFO] Starting Coding Trace 1/2"
MOE_TRACE_OUT="$TRACE_DIR/trace-code.csv" "$BIN" \
  --model "/mnt/llms/Qwen3.8-Flash/Qwen3.8-Flash-Next-UD-IQ3_XXS-00001-of-00003.gguf" \
  --threads 6 \
  --n-gpu-layers 99 \
  --n-cpu-moe 99 \
  --load-mode "mmap" \
  --flash-attn "on" \
  --fit "off" \
  --no-sched-async-cpu \
  --cache-type-k "q8_0" \
  --cache-type-v "q8_0" \
  --ctx-size 131072 \
  --batch-size 2048 \
  --ubatch-size 512 \
  --prompt "Write a Zig (any version) implementation of an LRU cache with O(1) operations, then explain the memory layout in detail."

echo "[INFO] Starting Conversation Trace 2/2"
MOE_TRACE_OUT="$TRACE_DIR/trace-chat.csv" "$BIN" \
  --model "/mnt/llms/Qwen3.8-Flash/Qwen3.8-Flash-Next-UD-IQ3_XXS-00001-of-00003.gguf" \
  --threads 6 \
  --n-gpu-layers 99 \
  --n-cpu-moe 99 \
  --load-mode "mmap" \
  --flash-attn "on" \
  --fit "off" \
  --no-sched-async-cpu \
  --cache-type-k "q8_0" \
  --cache-type-v "q8_0" \
  --ctx-size 131072 \
  --batch-size 2048 \
  --ubatch-size 512 \
  -p "Analyze the trade-offs between monolithic and microkernel architectures from first principles."

echo "[INFO] Merging Traces..."
cat "$TRACE_DIR/trace-code.csv" "$TRACE_DIR/trace-chat.csv" >"$TRACE_DIR/qwen-merged.csv"

if [ -s "$TRACE_DIR/qwen-merged.csv" ]; then
  echo "[SUCCESS] Generated MoE Profile: $TRACE_DIR/qwen-merged.csv"
  head -n 5 "$TRACE_DIR/qwen-merged.csv"
else
  echo "[ERROR] Trace file is empty! Check if the binary supports MOE_TRACE_OUT."
fi
