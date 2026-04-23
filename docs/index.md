---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Nova"
  text: "Web Framework"
  tagline: A filesystem-based web framework for Luau runtimes, with out-of-the-box support for Lute, Lune and Zune.
  image:
    src: /nova.png
    alt: Nova Logo
  actions:
    - theme: brand
      text: Get Started
      link: /introduction/what-is-nova
    - theme: alt
      text: Guides
      link: guides/project-structure

features:
  - title: Middleware Support
    details: Easily chain logic together (like authentication or logging) before your main code runs
  - title: Filesystem Routing
    details: No manual route registration. Your folders are your paths
  - title: Runtime Agnostic
    details: Whether you prefer Lune, Zune, or Lute, Nova is built to work across the different Luau runtimes seamlessly
---

