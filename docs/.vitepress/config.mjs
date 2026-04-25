import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Nova",
  description: "A filesystem-based web framework for Luau runtimes, with out-of-the-box support for Lute, Lune and Zune.",
  head: [['link', { rel: 'icon', href: '/nova/favicon.ico' }]],
  base: "/nova/",
  themeConfig: {
    search: {
      provider: 'local'
    },
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Blog', link: '/blog/changelog' }
    ],

    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'What is Nova?', link: '/introduction/what-is-nova' },
          { text: 'Getting Started', link: '/introduction/getting-started' }
        ]
      },
      {
        text: 'Guides',
        items: [
          { text: 'Project Stucture', link: '/guides/project-structure' },
          { text: 'Routing', link: '/guides/routing' },
          { text: 'Request & Response', link: '/guides/req-res' },
          { text: 'Middlewares', link: '/guides/middleware' }
        ]
      },
      {
        text: 'Blog',
        items: [
          { text: 'Changelog', link: '/blog/changelog' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/nova-guild/nova' }
    ],
    editLink: {
        pattern: 'https://github.com/nova-guild/nova/edit/main/docs/:path',
        text: 'Edit this page on GitHub'
    }
  }
})
