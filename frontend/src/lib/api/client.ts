import axios from 'axios';
import type { ArticlesResponse, ArticleResponse } from '$lib/types';

const API_URL = 'http://localhost:4000/api';

const client = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add a request interceptor to add the auth token
client.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Token ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Add a response interceptor to handle errors
client.interceptors.response.use(
  (response) => response.data,
  (error) => {
    if (error.response?.data?.errors) {
      return Promise.reject(new Error(Object.values(error.response.data.errors).flat().join(', ')));
    }
    return Promise.reject(error);
  }
);

export const api = {
  // Auth
  login: (email: string, password: string) =>
    client.post('/users/login', { user: { email, password } }),
  
  register: (username: string, email: string, password: string) =>
    client.post('/users', { user: { username, email, password } }),
  
  getCurrentUser: () => client.get('/user'),
  
  // Articles
  getArticles: (params?: { tag?: string; author?: string; favorited?: string; limit?: number; offset?: number; feed?: boolean }) =>
    client.get<ArticlesResponse>(params?.feed ? '/articles/feed' : '/articles', { params }),
  
  getArticle: (slug: string) => client.get<ArticleResponse>(`/articles/${slug}`),
  
  createArticle: (article: { title: string; description: string; body: string; tagList?: string[] }) =>
    client.post<ArticleResponse>('/articles', { article }),
  
  updateArticle: (slug: string, article: { title?: string; description?: string; body?: string; tagList?: string[] }) =>
    client.put<ArticleResponse>(`/articles/${slug}`, { article }),
  
  deleteArticle: (slug: string) => client.delete(`/articles/${slug}`),
  
  favoriteArticle: (slug: string) => client.post<ArticleResponse>(`/articles/${slug}/favorite`),
  
  unfavoriteArticle: (slug: string) => client.delete<ArticleResponse>(`/articles/${slug}/favorite`),
  
  // Comments
  getComments: (slug: string) => client.get(`/articles/${slug}/comments`),
  
  addComment: (slug: string, body: string) =>
    client.post(`/articles/${slug}/comments`, { comment: { body } }),
  
  deleteComment: (slug: string, commentId: string) =>
    client.delete(`/articles/${slug}/comments/${commentId}`),
  
  // Profile
  getProfile: (username: string) => client.get(`/profiles/${username}`),
  
  followUser: (username: string) => client.post(`/profiles/${username}/follow`),
  
  unfollowUser: (username: string) => client.delete(`/profiles/${username}/follow`),
  
  // Tags
  getTags: () => client.get('/tags'),
};

export default api; 