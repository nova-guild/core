---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Mayari"
  text: "An Adaptive Luau Web Backend Framework"
  image:
    src: /mayari.png
    alt: Mayari
  actions:
    - theme: brand
      text: Get Started
      link: /docs/introduction/what-is-mayari
    - theme: alt
      text: Luau Guides
      link: /luau-guides/introduction

features:
  - title: Middleware Support
    details: Easily chain logic together (like authentication or logging) before your main code runs
  - title: Filesystem Routing
    details: No manual route registration. Your folders are your paths
  - title: Runtime Agnostic
    details: Whether you prefer Lune, Zune, or Lute, Mayari is built to work across the different Luau runtimes seamlessly
---

