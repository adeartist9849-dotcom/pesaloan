'use client';

import { useState } from 'react';
import {
  Search,
  Filter,
  MoreVertical,
  Eye,
  Edit,
  DollarSign,
  Clock,
  AlertTriangle,
  CheckCircle,
  XCircle,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import clsx from 'clsx';
import { format } from 'date-fns';

const mockLoans = [
  {
    id: 'LN-2024-001',
    customerId: '1',
    customerName: 'John Kamau',
    customerPhone: '254712345678',
    principal: 15000,
    interest: 1849,
    fees: 750,
    totalPayable: 17599,
    outstandingBalance: 17599,
    status: 'ACTIVE',
    dueDate: '2024-12-30',
    createdAt: '2024-12-01',
    termDays: 30,
  },
  {
    id: 'LN-2024-002',
    customerId: '2',
    customerName: 'Mary Wanjiku',
    customerPhone: '254723456789',
    principal: 10000,
    interest: 1233,
    fees: 500,
    totalPayable: 11733,
    outstandingBalance: 0,
    status: 'PAID',
    dueDate: '2024-11-30',
    createdAt: '2024-10-31',
    paidAt: '2024-11-28',
    termDays: 30,
  },
  {
    id: 'LN-2024-003',
    customerId: '4',
    customerName: 'Grace Akinyi',
    customerPhone: '254745678901',
    principal: 25000,
    interest: 3082,
    fees: 1250,
    totalPayable: 29332,
    outstandingBalance: 29332,
    status: 'OVERDUE',
    dueDate: '2024-12-15',
    createdAt: '2024-11-15',
    termDays: 30,
  },
  {
    id: 'LN-2024-004',
    customerId: '5',
    customerName: 'James Mwangi',
    customerPhone: '254756789012',
    principal: 5000,
    interest: 616,
    fees: 250,
    totalPayable: 5866,
    outstandingBalance: 5866,
    status: 'PENDING',
    dueDate: '2025-01-05',
    createdAt: '2024-12-20',
    termDays: 15,
  },
  {
    id: 'LN-2024-005',
    customerId: '3',
    customerName: 'Peter Ochieng',
    customerPhone: '254734567890',
    principal: 20000,
    interest: 2466,
    fees: 1000,
    totalPayable: 23466,
    outstandingBalance: 0,
    status: 'DECLINED',
    dueDate: '2024-12-25',
    createdAt: '2024-11-25',
    termDays: 30,
  },
];

const statusOptions = ['ALL', 'APPLICATION', 'PENDING', 'APPROVED', 'ACCEPTED', 'DISBURSEMENT_PENDING', 'ACTIVE', 'PAID', 'OVERDUE', 'RESOLVED', 'DEFAULTED', 'WRITTEN_OFF', 'DECLINED'];

export default function LoansPage() {
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const [sortConfig, setSortConfig] = useState<{ key: string; direction: 'asc' | 'desc' }>({ key: 'createdAt', direction: 'desc' });
  const [selectedRows, setSelectedRows] = useState<string[]>([]);
  const [expandedRow, setExpandedRow] = useState<string | null>(null);

  const filteredLoans = mockLoans.filter(loan => {
    const matchesSearch = 
      loan.customerName.toLowerCase().includes(search.toLowerCase()) ||
      loan.customerPhone.includes(search) ||
      loan.id.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === 'ALL' || loan.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const sortedLoans = [...filteredLoans].sort((a, b) => {
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
    if (selectedRows.length === filteredLoans.length) {
      setSelectedRows([]);
    } else {
      setSelectedRows(filteredLoans.map(l => l.id));
    }
  };

  const getStatusBadge = (status: string) => {
    const variants: Record<string, { class: string; icon: React.ReactNode }> = {
      ACTIVE: { class: 'badge-info', icon: <DollarSign className="w-3 h-3 mr-1" /> },
      PAID: { class: 'badge-success', icon: <CheckCircle className="w-3 h-3 mr-1" /> },
      OVERDUE: { class: 'badge-danger', icon: <AlertTriangle className="w-3 h-3 mr-1" /> },
      PENDING: { class: 'badge-warning', icon: <Clock className="w-3 h-3 mr-1" /> },
      DECLINED: { class: 'badge-gray', icon: <XCircle className="w-3 h-3 mr-1" /> },
      APPROVED: { class: 'badge-success', icon: <CheckCircle className="w-3 h-3 mr-1" /> },
      DISBURSEMENT_PENDING: { class: 'badge-warning', icon: <Clock className="w-3 h-3 mr-1" /> },
    };
    return variants[status] || { class: 'badge-gray', icon: null };
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

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Loans</h1>
          <p className="text-gray-500 mt-1">Manage loan applications and active loans</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="btn-secondary">Export CSV</button>
          <button className="btn-primary">Manual Review</button>
        </div>
      </div>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        <div className="card p-4">
          <p className="text-sm text-gray-500">Total Loans</p>
          <p className="text-2xl font-bold text-gray-900">{mockLoans.length}</p>
        </div>
        <div className="card p-4">
          <p className="text-sm text-gray-500">Active</p>
          <p className="text-2xl font-bold text-blue-600">
            {mockLoans.filter(l => l.status === 'ACTIVE').length}
          </p>
        </div>
        <div className="card p-4">
          <p className="text-sm text-gray-500">Overdue</p>
          <p className="text-2xl font-bold text-red-600">
            {mockLoans.filter(l => l.status === 'OVERDUE').length}
          </p>
        </div>
        <div className="card p-4">
          <p className="text-sm text-gray-500">Pending Review</p>
          <p className="text-2xl font-bold text-yellow-600">
            {mockLoans.filter(l => l.status === 'PENDING' || l.status === 'APPROVED').length}
          </p>
        </div>
        <div className="card p-4">
          <p className="text-sm text-gray-500">Total Outstanding</p>
          <p className="text-2xl font-bold text-gray-900">
            {formatCurrency(mockLoans.reduce((sum, l) => sum + l.outstandingBalance, 0))}
          </p>
        </div>
      </div>

      {/* Filters */}
      <div className="card p-4">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1 max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search by loan ID, customer name, phone..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="input-field pl-10"
            />
          </div>
          <div className="flex gap-2">
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="input-field w-auto min-w-[180px]"
            >
              {statusOptions.map(opt => <option key={opt} value={opt}>{opt.replace('_', ' ')}</option>)}
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
                    checked={selectedRows.length === filteredLoans.length && filteredLoans.length > 0}
                    onChange={handleSelectAll}
                    className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                </th>
                <th onClick={() => handleSort('id')} className="cursor-pointer select-none">
                  Loan ID {sortConfig.key === 'id' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('customerName')} className="cursor-pointer select-none">
                  Customer {sortConfig.key === 'customerName' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('principal')} className="cursor-pointer select-none">
                  Principal {sortConfig.key === 'principal' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Total Payable</th>
                <th>Outstanding</th>
                <th onClick={() => handleSort('status')} className="cursor-pointer select-none">
                  Status {sortConfig.key === 'status' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th onClick={() => handleSort('dueDate')} className="cursor-pointer select-none">
                  Due Date {sortConfig.key === 'dueDate' && (sortConfig.direction === 'asc' ? '↑' : '↓')}
                </th>
                <th>Term</th>
                <th className="w-12">Actions</th>
              </tr>
            </thead>
            <tbody>
              {sortedLoans.map((loan) => {
                const statusInfo = getStatusBadge(loan.status);
                const isOverdue = loan.status === 'OVERDUE';
                const daysOverdue = isOverdue ? Math.ceil((new Date().getTime() - new Date(loan.dueDate).getTime()) / (1000 * 60 * 60 * 24)) : 0;
                
                return (
                  <tr key={loan.id} className={clsx('hover:bg-gray-50', isOverdue && 'bg-red-50')}>
                    <td>
                      <input
                        type="checkbox"
                        checked={selectedRows.includes(loan.id)}
                        onChange={() => handleRowSelect(loan.id)}
                        className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                      />
                    </td>
                    <td className="font-mono font-medium text-gray-900">{loan.id}</td>
                    <td>
                      <div>
                        <p className="font-medium text-gray-900">{loan.customerName}</p>
                        <p className="text-xs text-gray-500">{formatPhone(loan.customerPhone)}</p>
                      </div>
                    </td>
                    <td className="font-medium text-gray-900">{formatCurrency(loan.principal)}</td>
                    <td className="text-gray-600">{formatCurrency(loan.totalPayable)}</td>
                    <td className="font-medium text-gray-900">{formatCurrency(loan.outstandingBalance)}</td>
                    <td>
                      <span className={clsx('badge', statusInfo.class)}>
                        {statusInfo.icon}
                        {loan.status.replace('_', ' ')}
                      </span>
                    </td>
                    <td className={isOverdue ? 'text-red-600 font-medium' : 'text-gray-600'}>
                      {format(new Date(loan.dueDate), 'dd MMM yyyy')}
                      {isOverdue && <span className="ml-2 text-xs text-red-600 font-medium">({daysOverdue}d overdue)</span>}
                    </td>
                    <td className="text-gray-600">{loan.termDays}d</td>
                    <td>
                      <div className="flex items-center justify-center gap-1">
                        <button
                          onClick={() => setExpandedRow(expandedRow === loan.id ? null : loan.id)}
                          className="p-2 rounded-lg hover:bg-gray-100 text-gray-600"
                          aria-label={expandedRow === loan.id ? 'Collapse' : 'Expand'}
                        >
                          {expandedRow === loan.id ? <ChevronLeft className="w-5 h-5" /> : <ChevronRight className="w-5 h-5" />}
                        </button>
                        <div className="relative">
                          <button className="p-2 rounded-lg hover:bg-gray-100 text-gray-600" aria-label="More actions">
                            <MoreVertical className="w-5 h-5" />
                          </button>
                        </div>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Expanded row details */}
        {expandedRow && (
          <tr className="bg-gray-50">
            <td colSpan={10} className="px-6 py-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 bg-white rounded-lg border border-gray-200">
                <div>
                  <p className="text-sm font-medium text-gray-500">Interest</p>
                  <p className="font-medium text-gray-900">{formatCurrency(mockLoans.find(l => l.id === expandedRow)?.interest || 0)}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-500">Fees</p>
                  <p className="font-medium text-gray-900">{formatCurrency(mockLoans.find(l => l.id === expandedRow)?.fees || 0)}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-500">Created</p>
                  <p className="font-medium text-gray-900">{format(new Date(mockLoans.find(l => l.id === expandedRow)?.createdAt || ''), 'dd MMM yyyy')}</p>
                </div>
              </div>
            </td>
          </tr>
        )}

        {/* Pagination */}
        <div className="px-4 py-3 border-t border-gray-200 flex items-center justify-between">
          <p className="text-sm text-gray-500">
            Showing {sortedLoans.length} of {mockLoans.length} loans
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