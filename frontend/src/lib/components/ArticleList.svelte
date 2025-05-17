<script lang="ts">
  import { onMount } from 'svelte';
  import { articles } from '$lib/stores/articles';
  import type { Article } from '$lib/types';
  import { formatDate } from '$lib/utils';

  export let feed = false;
  export let tag: string | undefined = undefined;
  export let author: string | undefined = undefined;
  export let favorited: string | undefined = undefined;

  onMount(() => {
    if (feed) {
      articles.loadFeed();
    } else {
      articles.loadArticles({ tag, author, favorited });
    }
  });

  function handleFavorite(article: Article) {
    if (article.favorited) {
      articles.unfavorite(article.slug);
    } else {
      articles.favorite(article.slug);
    }
  }
</script>

{#if $articles.loading}
  <div class="article-preview">Loading articles...</div>
{:else if $articles.error}
  <div class="article-preview text-red-500">{$articles.error}</div>
{:else if $articles.articles.length === 0}
  <div class="article-preview">No articles are here... yet.</div>
{:else}
  {#each $articles.articles as article}
    <article class="article-preview">
      <div class="article-meta">
        <a href="/profile/{article.author.username}">
          <img src={article.author.image || 'https://api.realworld.io/images/smiley-cyrus.jpeg'} alt={article.author.username} />
        </a>
        <div class="info">
          <a href="/profile/{article.author.username}" class="author">
            {article.author.username}
          </a>
          <span class="date">{formatDate(article.createdAt)}</span>
        </div>
        <button
          class="btn btn-sm {article.favorited ? 'btn-primary' : 'btn-outline-primary'}"
          on:click={() => handleFavorite(article)}
        >
          <i class="ion-heart"></i>
          <span class="counter">({article.favoritesCount})</span>
        </button>
      </div>
      <a href="/article/{article.slug}" class="preview-link">
        <h1>{article.title}</h1>
        <p>{article.description}</p>
        <span>Read more...</span>
        <ul class="tag-list">
          {#each article.tagList as tag}
            <li class="tag-default tag-pill tag-outline">{tag}</li>
          {/each}
        </ul>
      </a>
    </article>
  {/each}
{/if}

<style>
  .article-preview {
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    padding: 1.5rem 0;
  }

  .article-meta {
    display: flex;
    align-items: center;
    margin-bottom: 1rem;
  }

  .article-meta img {
    width: 32px;
    height: 32px;
    border-radius: 30px;
    margin-right: 0.5rem;
  }

  .info {
    flex: 1;
  }

  .author {
    display: block;
    font-weight: 500;
    color: #5cb85c;
    text-decoration: none;
  }

  .date {
    color: #bbb;
    font-size: 0.8rem;
    display: block;
  }

  .preview-link {
    color: inherit;
    text-decoration: none;
  }

  .preview-link h1 {
    font-weight: 600;
    font-size: 1.5rem;
    margin-bottom: 3px;
  }

  .preview-link p {
    font-weight: 300;
    font-size: 1rem;
    color: #999;
    margin-bottom: 15px;
  }

  .preview-link span {
    max-width: 30%;
    font-size: 0.8rem;
    font-weight: 300;
    color: #bbb;
    vertical-align: middle;
  }

  .tag-list {
    display: inline-block;
    margin-left: 0.5rem;
    padding-left: 0;
    list-style: none;
  }

  .tag-list li {
    display: inline-block;
    margin-right: 3px;
    font-size: 0.8rem;
    padding: 0.1rem 0.6rem;
    border-radius: 10rem;
    border: 1px solid #ddd;
    color: #aaa;
  }
</style> 