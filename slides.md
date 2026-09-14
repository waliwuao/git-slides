---
theme: default
title: 从崩溃到协作 - Git 实战
info: |
  Git 实战课程：从代码崩溃到多人 / 多 AI 协作
class: text-center
highlighter: shiki
lineNumbers: false
transition: slide-left
mdc: true
colorSchema: dark
drawings:
  persist: false
---

# 从崩溃到协作

用 Git 保住你的代码

<div class="pt-12 opacity-70">
四个崩溃现场 · 一套解法 · 从单机到团队
</div>

<div class="abs-br m-6 text-sm opacity-50">
Git 实战课程
</div>

<!--
开场不要讲命令。先问：谁丢过代码？谁被 AI 改崩过？
-->

---
layout: center
---

# 四个崩溃现场，Git 都能救

<v-clicks>

1. 自己熬夜写崩，回不到能跑的版本
2. AI 把能跑的项目改崩，还看不懂它改了什么
3. 要把代码发给队友，只能传压缩包
4. 两个人 / 两个 AI 同时改，互相覆盖

</v-clicks>

<div v-after class="pt-8 text-sm opacity-60">
① ② 用「回退」解决 · ③ 用「分发」解决 · ④ 用「协作」解决
</div>

---
layout: section
---

# 第一幕

## 崩溃与回退

---

# 崩溃现场：自己写崩 / 被 AI 改崩

<div class="grid grid-cols-2 gap-8 items-stretch">

<div class="crash-card fake-versioning">
<div class="tag">自己写崩</div>

满屏"最终版"，却不知道哪个能跑：

```
main.py
main_最终版.py
main_真的最终版.py
main_最终版_别删.zip
```

</div>

<div class="crash-card">
<div class="tag">被 AI 改崩</div>

AI 一口气改了 12 个文件，项目跑不起来；编辑器已经保存，<span class="pain">原代码没了</span>。

</div>

</div>

<div v-click class="pt-8 text-center text-lg">

结论：<span class="relief">AI 不是不能碰你的代码，而是每次碰之前，你要能回退。</span>

</div>

---

# Git 不是网盘，是时间机器

<div class="flex items-center justify-center gap-3 text-center">

<div class="crash-card flex-1">
<div class="tag">工作区</div>
你正在编辑的文件
</div>

<div class="cmd whitespace-nowrap">— git add →</div>

<div class="crash-card flex-1">
<div class="tag">暂存区</div>
本次要存档的改动
</div>

<div class="cmd whitespace-nowrap">— git commit →</div>

<div class="crash-card flex-1">
<div class="tag">本地仓库</div>
一个个存档点
</div>

</div>

<div v-click class="pt-10 text-center text-lg">

<span class="cmd">commit</span> = 一次存档。只要存过档，你永远回得去。

</div>

<!--
用"游戏存档点"类比最关键：只要存过档，就能读档。
-->

---

# 让 AI 动手之前，先存档

````md magic-move
```bash
git add .
git commit -m "AI 重构前的稳定版本"
```
```bash
# 存档之后，再让 AI 放心重构
```
```bash
git restore .
```
````

<div v-after class="pt-8 text-center text-lg">

顺序永远是：<span class="cmd">先 commit</span> → 再让 AI 改 → 崩了就 <span class="cmd">restore</span>。

</div>

<!--
全课最重要的习惯：演示时故意让 AI 改崩，再用 restore 救回来。
-->

---

# 改崩了怎么办

<div class="grid grid-cols-3 gap-6">

<div>
<h3 class="!mt-0">丢弃未存档</h3>

```bash
git restore .
```

<span class="text-sm opacity-70">回到上次存档</span>
</div>

<div>
<h3 class="!mt-0">回退到某次存档</h3>

```bash
git reset --hard HEAD~1
```

<span class="text-sm opacity-70">抹掉最近一次提交</span>
</div>

<div>
<h3 class="!mt-0">撤销已推送的提交</h3>

```bash
git revert <commit>
```

<span class="text-sm opacity-70">安全，不改历史</span>
</div>

</div>

<div v-click class="pt-8 text-center text-lg">

终极后悔药：<span class="cmd">git reflog</span> —— 连 reset 掉的也能找回来。

</div>

---
layout: section
---

# 第二幕

## 分发

---
layout: two-cols
---

# 崩溃现场：分发

::right::

用微信 / 网盘传 zip 的三种翻车现场：

<v-clicks class="pl-6 pt-4">

- 文件太大，传不动
- 传了一半，对方不知道
- 两边都改了，谁的算？

</v-clicks>

<div v-click class="pt-6">

根源：<span class="pain">压缩包没有"历史"，也没有"同步"。</span>

</div>

---

# 第二幕解法：远程仓库

<div class="grid grid-cols-2 gap-8">

<div>

<h3 class="!mt-0">用 gh 一键建仓并推送</h3>

```bash
gh repo create git-slides \
  --public --source=. --push
```

</div>

<div>

<h3 class="!mt-0">别人一键克隆</h3>

```bash
gh repo clone <owner>/git-slides
```

</div>

</div>

<div v-click class="pt-8 text-center">

托管在 <span class="cmd">GitHub</span>：远程仓库 = 带历史的云端副本。

</div>

<div v-click class="pt-4 text-center text-lg">

首次使用先 <span class="cmd">gh auth login</span>；顺手用 <span class="cmd">.gitignore</span> 挡掉 <code>node_modules</code>、<code>.env</code> 和密钥。

</div>

---
layout: section
---

# 第三幕

## 协作

---
layout: two-cols
---

# 崩溃现场：协作

::right::

- 你改 A 文件，队友改 B 文件，结果互相覆盖
- 两个 AI 并行改同一份代码，改完谁也合不进去
- "我明明改了，怎么没了？"

<div v-click class="pt-6">

根源：<span class="pain">所有人挤在同一条时间线上。</span>

</div>

---

# 第三幕解法：分支

<div class="text-center opacity-70">每个人 / 每个任务 / 每个 AI，各开一条分支</div>

<GitGraph autoplay />

```bash
git switch -c feature/login    # 开一条新分支并切过去
git merge feature/login        # 改完了，合回主线
```

<!--
GitGraph 自动播放：主线、AI 分支、修复、合并。
手动控制可用 <GitGraph :step="2" />。
-->

---

# 冲突：不是错误，是选择

<div class="grid grid-cols-2 gap-8">

<div>

同一行代码被两边改了，Git 无法替你决定：

```bash
<<<<<<< HEAD
return 200
=======
return 404
>>>>>>> feature/api
```

</div>

<div v-click>

处理方式：

1. 手动选择保留哪边（或都改）

```bash
return 404
```

2. 删掉 `<<<<<<<` / `=======` / `>>>>>>>`
3. `git add` → `git commit`

</div>

</div>

---

# 多 AI 协作：分支 + PR

<div class="grid grid-cols-4 gap-4 text-center">

<div class="crash-card">
<div class="tag">1 推</div>
把分支推到 GitHub
</div>

<div class="crash-card">
<div class="tag">2 开</div>
开 Pull Request，写清改了什么
</div>

<div class="crash-card">
<div class="tag">3 审</div>
队友 review，跑通测试
</div>

<div class="crash-card">
<div class="tag">4 合</div>
通过后再合进主线
</div>

</div>

<div v-click class="pt-10 text-center text-lg">

每个 AI 各开分支 → 开 PR → 审查后合并，<span class="relief">AI 改崩也不怕，随时可回退</span>。

</div>

---
layout: center
---

# 一句话总结

<div class="pt-6 text-xl leading-relaxed">

先 <span class="cmd">commit</span>，再动手 —— 无论动手的是你还是 AI。

<br />

用 <span class="cmd">远程</span> 分发，用 <span class="cmd">分支</span> 协作。

<br />

只要能 <span class="relief">回退</span>，你就永远不会真的崩溃。

</div>

---
layout: end
---

# Q & A

记住：先 <span class="cmd">commit</span>，再动手。
