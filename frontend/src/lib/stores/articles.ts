import { writable } from 'svelte/store';
import { api } from '$lib/api/client';
import type { Article } from '$lib/types';

interface ArticlesState {
  articles: Article[];
  articlesCount: number;
  loading: boolean;
  error: string | null;
}

function createArticlesStore() {
  const { subscribe, set, update } = writable<ArticlesState>({
    articles: [],
    articlesCount: 0,
    loading: false,
    error: null
  });

  return {
    subscribe,
    loadArticles: async (params?: { tag?: string; author?: string; favorited?: string; limit?: number; offset?: number }) => {
      update(state => ({ ...state, loading: true, error: null }));
      try {
        const response = await api.getArticles(params);
        set({
          articles: response.articles,
          articlesCount: response.articlesCount,
          loading: false,
          error: null
        });
      } catch (error) {
        update(state => ({
          ...state,
          loading: false,
          error: error instanceof Error ? error.message : 'Failed to load articles'
        }));
      }
    },
    loadFeed: async (params?: { limit?: number; offset?: number }) => {
      update(state => ({ ...state, loading: true, error: null }));
      try {
        const response = await api.getArticles({ ...params, feed: true });
        set({
          articles: response.articles,
          articlesCount: response.articlesCount,
          loading: false,
          error: null
        });
      } catch (error) {
        update(state => ({
          ...state,
          loading: false,
          error: error instanceof Error ? error.message : 'Failed to load feed'
        }));
      }
    },
    favorite: async (slug: string) => {
      try {
        await api.favoriteArticle(slug);
        update(state => ({
          ...state,
          articles: state.articles.map(article =>
            article.slug === slug
              ? { ...article, favorited: true, favoritesCount: article.favoritesCount + 1 }
              : article
          )
        }));
      } catch (error) {
        update(state => ({
          ...state,
          error: error instanceof Error ? error.message : 'Failed to favorite article'
        }));
      }
    },
    unfavorite: async (slug: string) => {
      try {
        await api.unfavoriteArticle(slug);
        update(state => ({
          ...state,
          articles: state.articles.map(article =>
            article.slug === slug
              ? { ...article, favorited: false, favoritesCount: article.favoritesCount - 1 }
              : article
          )
        }));
      } catch (error) {
        update(state => ({
          ...state,
          error: error instanceof Error ? error.message : 'Failed to unfavorite article'
        }));
      }
    }
  };
}

export const articles = createArticlesStore(); 