import axios, { AxiosInstance, AxiosError, InternalAxiosRequestConfig } from 'axios';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth/auth-options';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api/v1';

class ApiClient {
  private client: AxiosInstance;
  private accessToken: string | null = null;
  private refreshToken: string | null = null;

  constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      headers: {
        'Content-Type': 'application/json',
      },
      timeout: 30000,
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    // Request interceptor - add auth token
    this.client.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        if (this.accessToken) {
          config.headers.Authorization = `Bearer ${this.accessToken}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // Response interceptor - handle token refresh
    this.client.interceptors.response.use(
      (response) => response,
      async (error: AxiosError) => {
        const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean };

        if (error.response?.status === 401 && !originalRequest._retry && this.refreshToken) {
          originalRequest._retry = true;

          try {
            const response = await axios.post(`${API_BASE_URL}/auth/refresh`, {
              refreshToken: this.refreshToken,
            });

            this.setTokens(response.data.accessToken, response.data.refreshToken);
            originalRequest.headers.Authorization = `Bearer ${this.accessToken}`;

            return this.client(originalRequest);
          } catch (refreshError) {
            this.clearTokens();
            // Redirect to login
            if (typeof window !== 'undefined') {
              window.location.href = '/login';
            }
            return Promise.reject(refreshError);
          }
        }

        return Promise.reject(error);
      }
    );
  }

  setTokens(accessToken: string, refreshToken: string) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('accessToken', accessToken);
      localStorage.setItem('refreshToken', refreshToken);
    }
  }

  loadTokensFromStorage() {
    if (typeof window !== 'undefined') {
      this.accessToken = localStorage.getItem('accessToken');
      this.refreshToken = localStorage.getItem('refreshToken');
    }
  }

  clearTokens() {
    this.accessToken = null;
    this.refreshToken = null;
    
    if (typeof window !== 'undefined') {
      localStorage.removeItem('accessToken');
      localStorage.removeItem('refreshToken');
    }
  }

  // Auth
  async login(phoneNumber: string, pin: string) {
    const response = await this.client.post('/auth/login', { phoneNumber, pin });
    this.setTokens(response.data.accessToken, response.data.refreshToken);
    return response.data;
  }

  async adminLogin(email: string, password: string) {
    const response = await this.client.post('/admin/auth/login', { email, password });
    this.setTokens(response.data.accessToken, response.data.refreshToken);
    return response.data;
  }

  async logout() {
    if (this.refreshToken) {
      try {
        await this.client.post('/auth/logout', { refreshToken: this.refreshToken });
      } catch {}
    }
    this.clearTokens();
  }

  async getProfile() {
    const response = await this.client.get('/users/profile');
    return response.data;
  }

  // Customers
  async getCustomers(params?: { page?: number; limit?: number; search?: string; kycStatus?: string; accountStatus?: string }) {
    const response = await this.client.get('/admin/customers', { params });
    return response.data;
  }

  async getCustomer(id: string) {
    const response = await this.client.get(`/admin/customers/${id}`);
    return response.data;
  }

  async updateCustomerStatus(id: string, status: string) {
    const response = await this.client.patch(`/admin/customers/${id}/status`, { status });
    return response.data;
  }

  // Loans
  async getLoans(params?: { page?: number; limit?: number; status?: string; search?: string }) {
    const response = await this.client.get('/admin/loans', { params });
    return response.data;
  }

  async approveLoan(id: string) {
    const response = await this.client.post(`/admin/loans/${id}/approve`);
    return response.data;
  }

  async declineLoan(id: string, reason: string) {
    const response = await this.client.post(`/admin/loans/${id}/decline`, { reason });
    return response.data;
  }

  // Payments
  async getPayments(params?: { page?: number; limit?: number; type?: string; status?: string; provider?: string; search?: string }) {
    const response = await this.client.get('/admin/payments', { params });
    return response.data;
  }

  // Credit Rules
  async getCreditRules() {
    const response = await this.client.get('/admin/credit/rules');
    return response.data;
  }

  async updateCreditRules(data: any) {
    const response = await this.client.put('/admin/credit/rules', data);
    return response.data;
  }

  // Audit Logs
  async getAuditLogs(params?: { page?: number; limit?: number; action?: string; entityType?: string; userId?: string; adminId?: string; fromDate?: string; toDate?: string }) {
    const response = await this.client.get('/admin/audit-logs', { params });
    return response.data;
  }

  // Dashboard
  async getDashboardStats() {
    const response = await this.client.get('/admin/dashboard/stats');
    return response.data;
  }
}

export const api = new ApiClient();

// Client-side hook for React components
export function useApi() {
  // In a real app, you'd use React context or SWR/TanStack Query
  return api;
}