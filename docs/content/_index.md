---
title: 我的个人博客
layout: hextra-home
---

{{< hextra/hero-badge link="blog" >}}
  <span>个人主页 · 技术博客 · 项目记录</span>
  {{< icon name="arrow-circle-right" attributes="height=14" >}}
{{< /hextra/hero-badge >}}

<div class="hx:mt-6 hx:mb-6">
{{< hextra/hero-headline >}}
  你好，我在这里记录&nbsp;<br class="hx:sm:block hx:hidden" />技术、项目和思考
{{< /hextra/hero-headline >}}
</div>

<div class="hx:mb-12">
{{< hextra/hero-subtitle >}}
  这是我的个人主页和博客。以后每一篇文章都会放在这里，方便沉淀经验、整理项目，也方便别人了解我正在做什么。
{{< /hextra/hero-subtitle >}}
</div>

<div class="hx:flex hx:flex-wrap hx:justify-center hx:gap-3 hx:mb-12">
  {{< hextra/hero-button text="阅读博客" link="blog" >}}
  {{< hextra/hero-button text="查看项目" link="projects" >}}
</div>

{{< hextra/feature-grid >}}
  {{< hextra/feature-card
    title="博客文章"
    subtitle="记录技术学习、问题排查、工具使用和阶段性复盘。你以后主要在 content/blog 下新增 Markdown 文件。"
    icon="newspaper"
    link="blog"
  >}}
  {{< hextra/feature-card
    title="项目作品"
    subtitle="整理做过的项目、开源实践和可以公开展示的作品。适合放 GitHub 仓库、演示链接和项目总结。"
    icon="collection"
    link="projects"
  >}}
  {{< hextra/feature-card
    title="关于我"
    subtitle="放个人介绍、技能方向、联系方式和近期关注的主题。后续可以慢慢补充成一张完整名片。"
    icon="user"
    link="about"
  >}}
  {{< hextra/feature-card
    title="归档"
    subtitle="所有文章会按时间自动归档，写得越多，这里越像你的个人知识时间线。"
    icon="calendar"
    link="archives"
  >}}
{{< /hextra/feature-grid >}}
