'use client';

import { useState } from 'react';
import {
  Search,
  Filter,
  MoreVertical,
  Eye,
  DollarSign,
  ArrowUp,
  ArrowDown,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Clock,
  ChevronLeft,
  ChevronRight,
  Download,
} from 'lucide-react';
import clsx from 'clsx';
import { format } from 'date-fns';

const mockPayments = [
  {
    id: 'TXN-2024-001',
    loanId: 'LN-2024-001',
    customerName: 'John Kamau',
    customerPhone: '254712345678',
    type: 'DISBURSEMENT',
    amount: 15000,
    status: 'COMPLETED',
    reference: 'MPESA-20241201-001',
    providerReference: 'OEI2345678',
    provider: 'MPESA',
    createdAt: '2024-12-01T10:30:00',
    processedAt: '2024-12-01T10:30:15',
  },
  {
    id: 'TXN-2024-002',
    loanId: 'LN-2024-002',
    customerName: 'Mary Wanjiku',
    customerPhone: '254723456789',
    type: 'REPAYMENT',
    amount: 11733,
    status: 'COMPLETED',
    reference: 'REPAY-20241128-001',
    providerReference: 'OEI2345679',
    provider: 'MPESA',
    createdAt: '2024-11-28T14:22:00',
    processedAt: '2024-11-28T14:22:10',
  },
  {
    id: 'TXN-2024-003',
    loanId: 'LN-2024-003',
    customerName: 'Grace Akinyi',
    customerPhone: '254745678901',
    type: 'DISBURSEMENT',
    amount: 25000,
    status: 'COMPLETED',
    reference: 'MPESA-20241115-001',
    providerReference: 'OEI2345680',
    provider: 'MPESA',
    createdAt: '2024-11-15T09:15:00',
    processedAt: '2024-11-15T09:15:20',
  },
  {
    id: 'TXN-2024-004',
    loanId: 'LN-2024-003',
    customerName: 'Grace Akinyi',
    customerPhone: '254745678901',
    type: 'REPAYMENT',
    amount: 10000,
    status: 'FAILED',
    reference: 'REPAY-20241215-001',
    providerReference: 'OEI2345681',
    provider: 'MPESA',
    createdAt: '2024-12-15T16:45:00',
    processedAt: '2024-12-15T16:45:30',
    failedReason: 'Insufficient funds',
  },
  {
    id: 'TXN-2024-005',
    loanId: 'LN-2024-004',
    customerName: 'James Mwangi',
    customerPhone: '254756789012',
    type: 'DISBURSEMENT',
    amount: 5000,
    status: 'PENDING',
    reference: 'MPESA-20241220-001',
    providerReference: null,
    provider: 'MPESA',
    createdAt: '2024-12-20T11:00:00',
    processedAt: null,
  },
];

const typeOptions = ['ALL', 'DISBURSEMENT', 'REPAYMENT', 'FEE', 'PENALTY', 'REFUND', 'ADJUSTMENT'];
const statusOptions = ['ALL', 'PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REVERSED'];
const providerOptions = ['ALL', 'MPESA', 'AIRTEL_MONEY'];

export default function PaymentsPage() {
  const [search, setSearch] = useState('');
  const [typeFilter, setTypeFilter] = useState('ALL');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [providerFilter, setProviderFilter] = useState('ALL');
  const [dateRange, setDateRange] = useState('LAST_7_DAYS');
  const [currentPage, setCurrentPage] = useState(1);
  const [sortConfig, setSortConfig] = useState<{ key: string; direction: 'asc' | 'desc' }>({ key: 'createdAt', direction: 'desc' });
  const [selectedRows, setSelectedRows] = useState<string[]>([]);

  const filteredPayments = mockPayments.filter(payment => {
    const matchesSearch = 
      payment.customerName.toLowerCase().includes(search.toLowerCase()) ||
      payment.customerPhone.includes(search) ||
      payment.id.toLowerCase().includes(search.toLowerCase()) ||
      payment.reference.toLowerCase().includes(search.toLowerCase());
    const matchesType = typeFilter === 'ALL' || payment.type === typeFilter;
    const matchesStatus = statusFilter === 'ALL' || payment.status === statusFilter;
    const matchesProvider = providerFilter === 'ALL' || payment.provider === providerFilter;
    return matchesSearch && matchesType && matchesStatus && matchesProvider;
  });

  const sortedPayments = [...filteredPayments].sort((a, b) => {
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
    if (selectedRows.length === filteredPayments.length) {
      setSelectedRows([]);
    } else {
      setSelectedRows(filteredPayments.map(p => p.id));
    }
  };

  const getStatusBadge = (status: string) => {
    const variants: Record<string, { class: string; icon: React.ReactNode }> = {
      COMPLETED: { class: 'badge-success', icon: <CheckCircle className="w-3 h-3 mr-1" /> },
      PENDING: { class: 'badge-warning', icon: <Clock className="w-3 h-3 mr-1" /> },
      PROCESSING: { class: 'badge-info', icon: <Clock className="w-3 h-3 mr-1" /> },
      FAILED: { class: 'badge-danger', icon: <XCircle className="w-3 h-3 mr-1" /> },
      REVERSED: { class: 'badge-gray', icon: <ArrowDown className="w-3 h-3 mr-1" /> },
    };
    return variants[status] || { class: 'badge-gray', icon: null };
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'DISBURSEMENT': return <ArrowDown className="w-4 h-4 text-green-600" />;
      case 'REPAYMENT': return <ArrowUp className="w-4 h-4 text-blue-600" />;
      case 'FEE': return <DollarSign className="w-4 h-4 text-yellow-600" />;
      case 'PENALTY': return <AlertTriangle className="w-4 h-4 text-red-600" />;
      default: return <DollarSign className="w-4 h-4 text-gray-600" />;
    }
  };

  const formatPhone = (phone: string) => {
    if (phone.startsWith('254')) {
      return `+254 ${phone.slice(3, 6)} ${phone.slice(6, 9)} ${phone.slice(9)}`;
    }
    return phone;
  };

  const formatCurrency = (amount: number) => {
    return `KES ${amount.toLocaleString()}`;
  };

  // Summary calculations
  const totalDisbursed = mockPayments
    .filter(p => p.type === 'DISBURSEMENT' && p.status === 'COMPLETED')
    .reduce((sum, p) => sum + p.amount, 0);
  
  const totalRepaid = mockPayments
    .filter(p => p.type === 'REPAYMENT' && p.status === 'COMPLETED')
    .reduce((sum, p) => sum + p.amount, 0);
  
  const pendingCount = mockPayments.filter(p => p.status === 'PENDING' || p.status === 'PROCESSING').length;
  const failedCount = mockPayments.filter(p => p.status === 'FAILED').length;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Payments</h1>
          <p className="text-gray-500 mt-1">Track disbursements, repayments and transaction history</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="btn-secondary">
            <Download className="w-4 h-4 mr-2" />
            Export CSV
          </button>
          <button className="btn-secondary">Reconcile</button>
        </div>
      </div>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="card p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Total Disbursed</p>
              <p className="text-2xl font-bold text-gray-900">{formatCurrency(totalDisbursed)}</p>
            </div>
            <div className="p-3 bg-green-100 rounded-xl">
              <ArrowDown className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </div>
        <div className="card p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Total Repaid</p>
              <p className="text-2xl font-bold text-gray-900">{formatCurrency(totalRepaid)}</p>
            </div>
            <div className="p-3 bg-blue-100 rounded-xl">
              <ArrowUp className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </div>
        <div className="card p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Pending</p>
              <p className="text-2xl font-bold text-yellow-600">{pendingCount}</p>
            </div>
            <div className="p-3 bg-yellow-100 rounded-xl">
              <Clock className="w-6 h-6 text-yellow-600" />
            </div>
          </div>
        </div>
        <div className="card p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Failed</p>
              <p className="text-2xl font-bold text-red-600">{failedCount}</p>
            </div>
            <div className="p-3 bg-red-100 rounded-xl">
              <XCircle className="w-6 h-6 text-red-600" />
            </div>
          </div>
        </div>
      </div>

      {/* Filters */}
      <div className="card p-4">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1 max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search by ID, customer, reference..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="input-field pl-10"
            />
          </div>
          <div className="flex flex-wrap gap-2">
            <select value={typeFilter} onChange={(e) => setTypeFilter(e.target.value)} className="input-field w-auto min-w-[150px]">
              {typeOptions.map(opt => <option key={opt} value={opt}>{opt}</option>)}
            </select>
            <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)} className="input-field w-auto min-w-[150px]">
              {statusOptions.map(opt => <option key={opt} value={opt}>{opt}</option>)}
            </select>
            <select value={providerFilter} onChange={(e) => setProviderFilter(e.target.value)} className="input-field w-auto min-w-[150px]">
              {providerOptions.map(opt => <option key={opt} value={opt}>{opt}</option>)}
            </select>
            <select value={dateRange} onChange={(e) => setDateRange(e.target.value)} className="input-field w-auto min-w-[150px]">
              <option value="LAST_7_DAYS">Last 7 days</option>
              <option value="LAST_30_DAYS">Last 30 days</option>
              <option value="LAST_90_DAYS">Last 90 days</option>
              <option value="CUSTOM">Custom range</option>
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
                    checked={selectedRows.length === filteredPayments.length && filteredPayments.length > 0}
                    onChange={handleSelectAll}
                    className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                </th>
                <th onClick={() => handleSort('id')} className="cursor-pointer select-none">
                  Transaction ID {sortConfig.key === 'id' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Loan ID</th>
                <th onClick={() => handleSort('customerName')} className="cursor-pointer select-none">
                  Customer {sortConfig.key === 'customerName' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Type</th>
                <th onClick={() => handleSort('amount')} className="cursor-pointer select-none">
                  Amount {sortConfig.key === 'amount' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('status')} className="cursor-pointer select-none">
                  Status {sortConfig.key === 'status' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Provider</th>
                <th>Reference</th>
                <th onClick={() => handleSort('createdAt')} className="cursor-pointer select-none">
                  Date {sortConfig.key === 'createdAt' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th className="w-12">Actions</th>
              </tr>
            </thead>
            <tbody>
              {sortedPayments.map((payment) => {
                const statusInfo = getStatusBadge(payment.status);
                const typeIcon = getTypeIcon(payment.type);
                
                return (
                  <tr key={payment.id} className="hover:bg-gray-50">
                    <td>
                      <input
                        type="checkbox"
                        checked={selectedRows.includes(payment.id)}
                        onChange={() => handleRowSelect(payment.id)}
                        className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                      />
                    </td>
                    <td className="font-mono text-sm text-gray-900">{payment.id}</td>
                    <td className="font-mono text-sm text-gray-600">{payment.loanId}</td>
                    <td>
                      <div>
                        <p className="font-medium text-gray-900">{payment.customerName}</p>
                        <p className="text-xs text-gray-500">{formatPhone(payment.customerPhone)}</p>
                      </div>
                    </td>
                    <td>
                      <div className="flex items-center gap-2">
                        <span className="p-1 rounded bg-gray-100">{typeIcon}</span>
                        <span className="text-sm font-medium text-gray-700">{payment.type}</span>
                      </div>
                    </td>
                    <td className="font-medium text-gray-900">{formatCurrency(payment.amount)}</td>
                    <td>
                      <span className={clsx('badge', statusInfo.class)}>
                        {statusInfo.icon}
                        {payment.status}
                      </span>
                    </td>
                    <td className="text-gray-600">{payment.provider}</td>
                    <td className="font-mono text-sm text-gray-600">{payment.reference}</td>
                    <td className="text-gray-600 whitespace-nowrap">
                      {format(new Date(payment.createdAt), 'dd MMM yyyy HH:mm')}
                    </td>
                    <td>
                      <div className="flex items-center justify-center">
                        <button className="p-2 rounded-lg hover:bg-gray-100 text-gray-600" aria-label="View details">
                          <Eye className="w-5 h-5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-4 py-3 border-t border-gray-200 flex items-center justify-between">
          <p className="text-sm text-gray-500">
            Showing {sortedPayments.length} of {mockPayments.length} transactions
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