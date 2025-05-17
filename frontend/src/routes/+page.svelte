<script lang="ts">
  import { page } from '$app/stores';
  import ArticleList from '$lib/components/ArticleList.svelte';
  import { auth } from '$lib/stores/auth';

  $: isFeed = $page.url.searchParams.get('feed') === 'true';
</script>

<div class="home-page">
  <div class="banner">
    <div class="container">
      <h1 class="logo-font">conduit</h1>
      <p>A place to share your knowledge.</p>
    </div>
  </div>

  <div class="container page">
    <div class="row">
      <div class="col-md-9">
        <div class="feed-toggle">
          <ul class="nav nav-pills outline-active">
            {#if $auth.user}
              <li class="nav-item">
                <a
                  class="nav-link {isFeed ? 'active' : ''}"
                  href="?feed=true"
                  on:click|preventDefault={() => history.pushState({}, '', '?feed=true')}
                >
                  Your Feed
                </a>
              </li>
            {/if}
            <li class="nav-item">
              <a
                class="nav-link {!isFeed ? 'active' : ''}"
                href="?feed=false"
                on:click|preventDefault={() => history.pushState({}, '', '?feed=false')}
              >
                Global Feed
              </a>
            </li>
          </ul>
        </div>

        <ArticleList feed={isFeed} />
      </div>

      <div class="col-md-3">
        <div class="sidebar">
          <p>Popular Tags</p>

          <div class="tag-list">
            <!-- We'll add tags here later -->
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .home-page {
    .banner {
      background: #5cb85c;
      color: #fff;
      padding: 2rem 0;
      margin-bottom: 2rem;
      text-align: center;
    }

    .logo-font {
      font-family: titillium web, sans-serif;
      font-size: 3.5rem;
      padding-bottom: 1rem;
    }

    .banner p {
      font-weight: 300;
      font-size: 1.5rem;
      margin-bottom: 0;
    }

    .feed-toggle {
      margin-bottom: -1px;
    }

    .nav-pills {
      display: flex;
      border-bottom: 1px solid #ddd;
    }

    .nav-pills .nav-item {
      margin-right: 0.2rem;
    }

    .nav-pills .nav-link {
      border-radius: 0;
      color: #aaa;
      padding: 0.5rem 1rem;
      text-decoration: none;
    }

    .nav-pills .nav-link.active {
      color: #5cb85c;
      background: none;
      border-bottom: 2px solid #5cb85c;
    }

    .sidebar {
      padding: 5px 10px 10px;
      background: #f3f3f3;
      border-radius: 4px;
    }

    .sidebar p {
      margin-bottom: 0.2rem;
    }
  }
</style>
