<script lang="ts">
  import { goto } from '$app/navigation';
  import { api } from '$lib/api/client';
  import { auth } from '$lib/stores/auth';

  let email = '';
  let password = '';
  let errors: { [key: string]: string[] } = {};
  let loading = false;

  async function handleSubmit() {
    loading = true;
    errors = {};

    try {
      const response = await api.login(email, password);
      const user = response.data.user;
      localStorage.setItem('token', user.token);
      auth.setUser(user);
      goto('/');
    } catch (error: any) {
      if (error.response?.data?.errors) {
        errors = error.response.data.errors;
      } else {
        errors = { '': ['An unexpected error occurred'] };
      }
    } finally {
      loading = false;
    }
  }
</script>

<div class="auth-page">
  <div class="container page">
    <div class="row">
      <div class="col-md-6 offset-md-3 col-xs-12">
        <h1 class="text-xl font-bold mb-4">Sign in</h1>
        <p class="mb-4">
          <a href="/register" class="text-primary-600 hover:text-primary-700">Need an account?</a>
        </p>

        {#if errors['']}
          <ul class="error-messages">
            {#each errors[''] as error}
              <li class="text-red-500">{error}</li>
            {/each}
          </ul>
        {/if}

        <form on:submit|preventDefault={handleSubmit} class="space-y-4">
          <fieldset>
            <input
              type="email"
              bind:value={email}
              placeholder="Email"
              class="input"
              class:border-red-500={errors.email}
            />
            {#if errors.email}
              <ul class="error-messages">
                {#each errors.email as error}
                  <li class="text-red-500">{error}</li>
                {/each}
              </ul>
            {/if}
          </fieldset>

          <fieldset>
            <input
              type="password"
              bind:value={password}
              placeholder="Password"
              class="input"
              class:border-red-500={errors.password}
            />
            {#if errors.password}
              <ul class="error-messages">
                {#each errors.password as error}
                  <li class="text-red-500">{error}</li>
                {/each}
              </ul>
            {/if}
          </fieldset>

          <button
            type="submit"
            class="btn btn-primary w-full"
            disabled={loading}
          >
            {#if loading}
              Signing in...
            {:else}
              Sign in
            {/if}
          </button>
        </form>
      </div>
    </div>
  </div>
</div>

<style>
  .auth-page {
    max-width: 600px;
    margin: 0 auto;
    padding: 2rem;
  }

  .error-messages {
    list-style: none;
    padding: 0;
    margin: 0.5rem 0;
  }

  fieldset {
    margin-bottom: 1rem;
  }

  .input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 0.375rem;
    font-size: 1rem;
  }

  .input:focus {
    outline: none;
    border-color: var(--color-primary-500);
    box-shadow: 0 0 0 2px var(--color-primary-100);
  }

  .input.border-red-500 {
    border-color: #ef4444;
  }

  .btn {
    width: 100%;
    padding: 0.75rem;
    font-size: 1rem;
    font-weight: 500;
    border-radius: 0.375rem;
    transition: all 0.2s;
  }

  .btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }
</style> 