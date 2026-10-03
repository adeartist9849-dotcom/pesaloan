import '@testing-library/jest-dom';
import { jest } from '@jest/globals';

// Mock next/navigation
jest.mock('next/navigation', () => ({
  useRouter() {
    return {
      push: jest.fn(),
      replace: jest.fn(),
      prefetch: jest.fn(),
      back: jest.fn(),
    };
  },
  usePathname() {
    return '/dashboard';
  },
  useSearchParams() {
    return new URLSearchParams();
  },
}));

// Mock next-auth
jest.mock('next-auth/react', () => ({
  useSession() {
    return {
      data: {
        user: { id: '1', email: 'admin@test.com', name: 'Test Admin' },
        accessToken: 'mock-token',
      },
      status: 'authenticated',
    };
  },
  signIn: jest.fn(),
  signOut: jest.fn(),
}));

// Mock TanStack Query
jest.mock('@tanstack/react-query', () => ({
  useQuery: jest.fn(({ queryFn }) => ({
    data: null,
    isLoading: false,
    error: null,
    refetch: jest.fn(),
  })),
  useMutation: jest.fn(({ mutationFn }) => ({
    mutate: jest.fn(),
    mutateAsync: jest.fn(),
    isLoading: false,
    isError: false,
    isSuccess: false,
  })),
  QueryClient: jest.fn().mockImplementation(() => ({
    getQueryCache: () => ({ findAll: () => [] }),
    getMutationCache: () => ({ findAll: () => [] }),
  })),
  QueryClientProvider: ({ children }: { children: React.ReactNode }) => children,
}));

// Mock localStorage
const localStorageMock = {
  getItem: jest.fn(),
  setItem: jest.fn(),
  removeItem: jest.fn(),
  clear: jest.fn(),
};
global.localStorage = localStorageMock as unknown as Storage;

// Mock fetch
global.fetch = jest.fn() as any;