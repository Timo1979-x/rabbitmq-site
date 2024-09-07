import Vue from 'vue'
import VueRouter from 'vue-router'
import HomeView from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/signup',
    name: 'signup',
    component: () => import('../views/SignUp/Request.vue')
  },
  {
    path: '/signup/confirm',
    name: 'signup.confirm',
    component: () => import('../views/SignUp/Confirm.vue')
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import('../views/Profile/Show.vue')
  },
  {
    path: '/author',
    name: 'author',
    component: () => import('../views/Author/Show.vue')
  },
  {
    path: '/author/create',
    name: 'author.create',
    component: () => import('../views/Author/Create.vue')
  },
  {
    path: '/author/upload',
    name: 'author.upload',
    component: () => import('../views/Author/Video/Upload.vue')
  },
  {
    path: '/author/video/:id',
    name: 'author.video',
    component: () => import('../views/Author/Video/Show.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
