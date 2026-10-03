'use client';

import { useState } from 'react';
import {
  Search,
  Filter,
  MoreVertical,
  Eye,
  Edit,
  UserCheck,
  UserX,
  Download,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import clsx from 'clsx';

const mockCustomers = [
  {
    id: '1',
    phoneNumber: '254712345678',
    fullName: 'John Kamau',
    email: 'john.kamau@email.com',
    kycStatus: 'VERIFIED',
    accountStatus: 'ACTIVE',
    loanLimit: 50000,
    currentLoanStatus: 'ACTIVE',
    createdAt: '2024-01-15',
    lastActiveAt: '2024-12-20',
  },
  {
    id: '2',
    phoneNumber: '254723456789',
    fullName: 'Mary Wanjiku',
    email: 'mary.wanjiku@email.com',
    kycStatus: 'VERIFIED',
    accountStatus: 'ACTIVE',
    loanLimit: 30000,
    currentLoanStatus: 'PAID',
    createdAt: '2024-02-20',
    lastActiveAt: '2024-12-19',
  },
  {
    id: '3',
    phoneNumber: '254734567890',
    fullName: 'Peter Ochieng',
    email: 'peter.ochieng@email.com',
    kycStatus: 'PENDING_REVIEW',
    accountStatus: 'PENDING',
    loanLimit: 0,
    currentLoanStatus: null,
    createdAt: '2024-12-18',
    lastActiveAt: '2024-12-18',
  },
  {
    id: '4',
    phoneNumber: '254745678901',
    fullName: 'Grace Akinyi',
    email: 'grace.akinyi@email.com',
    kycStatus: 'VERIFIED',
    accountStatus: 'ACTIVE',
    loanLimit: 75000,
    currentLoanStatus: 'OVERDUE',
    createdAt: '2023-11-10',
    lastActiveAt: '2024-12-20',
  },
  {
    id: '5',
    phoneNumber: '254756789012',
    fullName: 'James Mwangi',
    email: 'james.mwangi@email.com',
    kycStatus: 'REJECTED',
    accountStatus: 'SUSPENDED',
    loanLimit: 0,
    currentLoanStatus: null,
    createdAt: '2024-03-05',
    lastActiveAt: '2024-12-15',
  },
];

const kycStatusOptions = ['ALL', 'VERIFIED', 'PENDING_REVIEW', 'NOT_STARTED', 'REJECTED', 'EXPIRED'];
const accountStatusOptions = ['ALL', 'ACTIVE', 'PENDING', 'SUSPENDED', 'CLOSED', 'BLOCKED'];

export default function CustomersPage() {
  const [search, setSearch] = useState('');
  const [kycFilter, setKycFilter] = useState('ALL');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const [sortConfig, setSortConfig] = useState<{ key: string; direction: 'asc' | 'desc' }>({ key: 'createdAt', direction: 'desc' });
  const [selectedRows, setSelectedRows] = useState<string[]>([]);
  const [expandedRow, setExpandedRow] = useState<string | null>(null);

  const filteredCustomers = mockCustomers.filter(customer => {
    const matchesSearch = 
      customer.fullName.toLowerCase().includes(search.toLowerCase()) ||
      customer.phoneNumber.includes(search) ||
      customer.email?.toLowerCase().includes(search.toLowerCase());
    const matchesKyc = kycFilter === 'ALL' || customer.kycStatus === kycFilter;
    const matchesStatus = statusFilter === 'ALL' || customer.accountStatus === statusFilter;
    return matchesSearch && matchesKyc && matchesStatus;
  });

  const sortedCustomers = [...filteredCustomers].sort((a, b) => {
    const aVal = (a[sortConfig.key as keyof typeof a] ?? '') as string | number;
    const bVal = (b[sortConfig.key as keyof typeof b] ?? '') as string | number;
    if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
    if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
    return 0;
  });

  const handleSort = (key: string) => {
    setSortConfig(prev => ({
      key,
      direction: prev.key === key && prev.direction === 'asc' ? 'desc' : 'asc',
    }));
  };

  const handleRowSelect = (id: string) => {
    setSelectedRows(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);
  };

  const handleSelectAll = () => {
    if (selectedRows.length === filteredCustomers.length) {
      setSelectedRows([]);
    } else {
      setSelectedRows(filteredCustomers.map(c => c.id));
    }
  };

  const getKycBadge = (status: string) => {
    const variants: Record<string, string> = {
      VERIFIED: 'badge-success',
      PENDING_REVIEW: 'badge-warning',
      NOT_STARTED: 'badge-gray',
      REJECTED: 'badge-danger',
      EXPIRED: 'badge-gray',
    };
    return variants[status] || 'badge-gray';
  };

  const getStatusBadge = (status: string) => {
    const variants: Record<string, string> = {
      ACTIVE: 'badge-success',
      PENDING: 'badge-warning',
      SUSPENDED: 'badge-danger',
      CLOSED: 'badge-gray',
      BLOCKED: 'badge-danger',
    };
    return variants[status] || 'badge-gray';
  };

  const formatPhone = (phone: string) => {
    if (phone.startsWith('254')) {
      return `+254 ${phone.slice(3, 6)} ${phone.slice(6, 9)} ${phone.slice(9)}`;
    }
    return phone;
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Customers</h1>
          <p className="text-gray-500 mt-1">Manage customer accounts and KYC status</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="btn-secondary">Export CSV</button>
          <button className="btn-primary">Add Customer</button>
        </div>
      </div>

      {/* Filters */}
      <div className="card p-4">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1 max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search by name, phone, email..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="input-field pl-10"
            />
          </div>
          <div className="flex gap-2">
            <select
              value={kycFilter}
              onChange={(e) => setKycFilter(e.target.value)}
              className="input-field w-auto"
            >
              {kycStatusOptions.map(opt => <option key={opt} value={opt}>{opt.replace('_', ' ')}</option>)}
            </select>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="input-field w-auto"
            >
              {accountStatusOptions.map(opt => <option key={opt} value={opt}>{opt}</option>)}
            </select>
          </div>
        </div>
      </div>

      {/* Table */}
      <div className="card overflow-hidden">
        <div className="table-container">
          <table className="table">
            <thead>
              <tr>
                <th className="w-12">
                  <input
                    type="checkbox"
                    checked={selectedRows.length === filteredCustomers.length && filteredCustomers.length > 0}
                    onChange={handleSelectAll}
                    className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                </th>
                <th onClick={() => handleSort('fullName')} className="cursor-pointer select-none">
                  Name {sortConfig.key === 'fullName' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('phoneNumber')} className="cursor-pointer select-none">
                  Phone {sortConfig.key === 'phoneNumber' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Email</th>
                <th onClick={() => handleSort('kycStatus')} className="cursor-pointer select-none">
                  KYC {sortConfig.key === 'kycStatus' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('accountStatus')} className="cursor-pointer select-none">
                  Status {sortConfig.key === 'accountStatus' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('loanLimit')} className="cursor-pointer select-none">
                  Loan Limit {sortConfig.key === 'loanLimit' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Current Loan</th>
                <th onClick={() => handleSort('lastActiveAt')} className="cursor-pointer select-none">
                  Last Active {sortConfig.key === 'lastActiveAt' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th className="w-12">Actions</th>
              </tr>
            </thead>
            <tbody>
              {sortedCustomers.map((customer) => (
                <tr key={customer.id} className="hover:bg-gray-50">
                  <td>
                    <input
                      type="checkbox"
                      checked={selectedRows.includes(customer.id)}
                      onChange={() => handleRowSelect(customer.id)}
                      className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                    />
                  </td>
                  <td className="font-medium text-gray-900">{customer.fullName}</td>
                  <td className="text-gray-600">{formatPhone(customer.phoneNumber)}</td>
                  <td className="text-gray-600">{customer.email || '-'}</td>
                  <td>
                    <span className={clsx('badge', getKycBadge(customer.kycStatus))}>
                      {customer.kycStatus.replace('_', ' ')}
                    </span>
                  </td>
                  <td>
                    <span className={clsx('badge', getStatusBadge(customer.accountStatus))}>
                      {customer.accountStatus}
                    </span>
                  </td>
                  <td className="font-medium text-gray-900">KES {customer.loanLimit.toLocaleString()}</td>
                  <td>
                    {customer.currentLoanStatus ? (
                      <span className={clsx('badge', 
                        customer.currentLoanStatus === 'ACTIVE' && 'badge-info',
                        customer.currentLoanStatus === 'OVERDUE' && 'badge-danger',
                        customer.currentLoanStatus === 'PAID' && 'badge-success'
                      )}>
                        {customer.currentLoanStatus}
                      </span>
                    ) : (
                      <span className="text-gray-400">—</span>
                    )}
                  </td>
                  <td className="text-gray-500">{customer.lastActiveAt}</td>
                  <td>
                    <div className="flex items-center justify-center gap-1">
                      <button
                        onClick={() => setExpandedRow(expandedRow === customer.id ? null : customer.id)}
                        className="p-2 rounded-lg hover:bg-gray-100 text-gray-600"
                        aria-label={expandedRow === customer.id ? 'Collapse' : 'Expand'}
                      >
                        {expandedRow === customer.id ? <ChevronLeft className="w-5 h-5" /> : <ChevronRight className="w-5 h-5" />}
                      </button>
                      <div className="relative">
                        <button className="p-2 rounded-lg hover:bg-gray-100 text-gray-600" aria-label="More actions">
                          <MoreVertical className="w-5 h-5" />
                        </button>
                      </div>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-4 py-3 border-t border-gray-200 flex items-center justify-between">
          <p className="text-sm text-gray-500">
            Showing {sortedCustomers.length} of {mockCustomers.length} customers
          </p>
          <div className="flex items-center gap-2">
            <button className="p-2 rounded-lg hover:bg-gray-100 disabled:opacity-50" disabled={currentPage === 1}>
              <ChevronLeft className="w-5 h-5" />
            </button>
            <span className="text-sm text-gray-600">Page {currentPage}</span>
            <button className="p-2 rounded-lg hover:bg-gray-100 disabled:opacity-50" disabled={currentPage >= 5}>
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}