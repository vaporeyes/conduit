import { writable } from 'svelte/store';
import type { Writable } from 'svelte/store';

interface User {
  email: string;
  token: string;
  username: string;
  bio: string | null;
  image: string | null;
}

interface AuthStore {
  user: User | null;
  loading: boolean;
}

function createAuthStore() {
  const { subscribe, set, update } = writable<AuthStore>({
    user: null,
    loading: true,
  });

  return {
    subscribe,
    setUser: (user: User | null) => update(store => ({ ...store, user, loading: false })),
    setLoading: (loading: boolean) => update(store => ({ ...store, loading })),
    logout: () => {
      localStorage.removeItem('token');
      set({ user: null, loading: false });
    },
  };
}

export const auth = createAuthStore(); 