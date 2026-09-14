<script setup>
import { onMounted, onUnmounted, ref, watch } from 'vue'

const props = defineProps({
  step: { type: Number, default: null },
  autoplay: { type: Boolean, default: false },
  interval: { type: Number, default: 900 },
})

const MAX_STEP = 4

const COLOR_MAIN = '#f05133'
const COLOR_BRANCH = '#3b82f6'
const COLOR_MERGE = '#eab308'

const nodes = [
  { id: 'A', x: 70, y: 170, msg: '初始化', step: 1, color: COLOR_MAIN, side: 'below' },
  { id: 'B', x: 190, y: 170, msg: '能跑的版本', step: 1, color: COLOR_MAIN, side: 'below' },
  { id: 'C', x: 330, y: 80, msg: 'AI 重构', step: 2, color: COLOR_BRANCH, side: 'above' },
  { id: 'D', x: 460, y: 80, msg: '改崩了', step: 2, color: COLOR_BRANCH, side: 'above' },
  { id: 'E', x: 460, y: 170, msg: '修复 bug', step: 3, color: COLOR_MAIN, side: 'below' },
  { id: 'M', x: 600, y: 170, msg: '合并', step: 4, color: COLOR_MERGE, side: 'below' },
]

const links = [
  { d: 'M70,170 L190,170', step: 1, color: COLOR_MAIN },
  { d: 'M190,170 C190,125 330,125 330,80', step: 2, color: COLOR_BRANCH },
  { d: 'M330,80 L460,80', step: 2, color: COLOR_BRANCH },
  { d: 'M190,170 L460,170', step: 3, color: COLOR_MAIN },
  { d: 'M460,170 L600,170', step: 4, color: COLOR_MAIN },
  { d: 'M460,80 C460,125 600,125 600,170', step: 4, color: COLOR_BRANCH },
]

const legend = [
  { color: COLOR_MAIN, text: '主线 main' },
  { color: COLOR_BRANCH, text: '分支 feature' },
  { color: COLOR_MERGE, text: '合并提交' },
]

const active = ref(props.step ?? 1)
let timer = null

watch(
  () => props.step,
  (v) => {
    if (v != null) active.value = v
  },
)

onMounted(() => {
  if (!props.autoplay) return
  let s = 1
  timer = setInterval(() => {
    if (s >= MAX_STEP) {
      clearInterval(timer)
      timer = null
      return
    }
    s += 1
    active.value = s
  }, props.interval)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

function isOn(step) {
  return active.value >= step
}

function labelY(n) {
  return n.side === 'above' ? n.y - 30 : n.y + 38
}
</script>

<template>
  <div class="gitgraph w-full flex justify-center">
    <svg viewBox="0 0 720 345" class="gitgraph-svg">
      <path
        v-for="(l, i) in links"
        :key="'link-' + i"
        :d="l.d"
        fill="none"
        :stroke="l.color"
        stroke-width="4"
        stroke-linecap="round"
        class="gg-line"
        :class="{ on: isOn(l.step) }"
      />
      <g
        v-for="n in nodes"
        :key="n.id"
        class="gg-node"
        :class="{ on: isOn(n.step) }"
      >
        <circle :cx="n.x" :cy="n.y" r="19" :fill="n.color" />
        <text :x="n.x" :y="n.y + 5" text-anchor="middle" class="gg-id">
          {{ n.id }}
        </text>
        <text :x="n.x" :y="labelY(n)" text-anchor="middle" class="gg-msg">
          {{ n.msg }}
        </text>
      </g>
      <g class="gg-legend">
        <g
          v-for="(item, i) in legend"
          :key="item.text"
          :transform="`translate(${70 + i * 205}, 318)`"
        >
          <circle cx="0" cy="0" r="8" :fill="item.color" />
          <text x="16" y="5" class="gg-legend-text">{{ item.text }}</text>
        </g>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.gitgraph-svg {
  width: 100%;
  max-width: 600px;
  height: auto;
  overflow: visible;
}

.gg-line {
  opacity: 0;
  transition: opacity 0.45s ease;
}

.gg-line.on {
  opacity: 1;
}

.gg-node {
  opacity: 0;
  transform: translateY(8px);
  transform-box: fill-box;
  transform-origin: center;
  transition:
    opacity 0.4s ease,
    transform 0.4s ease;
}

.gg-node.on {
  opacity: 1;
  transform: translateY(0);
}

.gg-id {
  fill: #ffffff;
  font-size: 14px;
  font-weight: 700;
}

.gg-msg {
  fill: currentColor;
  font-size: 14px;
  opacity: 0.9;
}

.gg-legend-text {
  fill: currentColor;
  font-size: 14px;
  opacity: 0.75;
}
</style>
