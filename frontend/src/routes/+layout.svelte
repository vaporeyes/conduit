<script lang="ts">
	import '../app.css';
	import { page } from '$app/stores';
	import { onMount } from 'svelte';
	import { api } from '$lib/api/client';
	import { auth } from '$lib/stores/auth';
	
	onMount(async () => {
		try {
			const token = localStorage.getItem('token');
			if (token) {
				const response = await api.getCurrentUser();
				auth.setUser(response.data.user);
			}
		} catch (error) {
			console.error('Error fetching user:', error);
			auth.logout();
		} finally {
			auth.setLoading(false);
		}
	});
	
	function logout() {
		auth.logout();
		window.location.href = '/';
	}
</script>

<div class="min-h-screen bg-gray-50">
	<nav class="bg-white shadow">
		<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
			<div class="flex justify-between h-16">
				<div class="flex">
					<div class="flex-shrink-0 flex items-center">
						<a href="/" class="text-2xl font-bold text-primary-600">Conduit</a>
					</div>
					<div class="hidden sm:ml-6 sm:flex sm:space-x-8">
						<a
							href="/"
							class="inline-flex items-center px-1 pt-1 border-b-2 {$page.url.pathname === '/' ? 'border-primary-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
						>
							Home
						</a>
						{#if $auth.user}
							<a
								href="/editor"
								class="inline-flex items-center px-1 pt-1 border-b-2 {$page.url.pathname === '/editor' ? 'border-primary-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
							>
								<i class="ion-compose"></i>&nbsp;New Article
							</a>
							<a
								href="/settings"
								class="inline-flex items-center px-1 pt-1 border-b-2 {$page.url.pathname === '/settings' ? 'border-primary-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
							>
								<i class="ion-gear-a"></i>&nbsp;Settings
							</a>
						{/if}
					</div>
				</div>
				<div class="hidden sm:ml-6 sm:flex sm:items-center">
					{#if $auth.user}
						<a
							href="/profile/{$auth.user.username}"
							class="inline-flex items-center px-1 pt-1 border-b-2 {$page.url.pathname.startsWith('/profile/') ? 'border-primary-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
						>
							{#if $auth.user.image}
								<img src={$auth.user.image} class="w-8 h-8 rounded-full mr-2" alt={$auth.user.username} />
							{/if}
							{$auth.user.username}
						</a>
						<button
							on:click={logout}
							class="ml-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
						>
							Sign out
						</button>
					{:else}
						<a
							href="/login"
							class="inline-flex items-center px-1 pt-1 border-b-2 {$page.url.pathname === '/login' ? 'border-primary-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
						>
							Sign in
						</a>
						<a
							href="/register"
							class="ml-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
						>
							Sign up
						</a>
					{/if}
				</div>
			</div>
		</div>
	</nav>

	<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
		<slot />
	</main>
</div>
