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
  AlertTriangle,
  CheckCircle,
  XCircle,
  Clock,
  Mail,
  Phone,
  MessageSquare,
  Shield,
  FileText,
  ChevronLeft,
  ChevronRight,
  Flag,
  Ban,
  Activity,
  Download,
} from 'lucide-react';
import clsx from 'clsx';
import { format } from 'date-fns';

const mockPendingReviews = [
  {
    id: 'APP-2024-001',
    customerName: 'Peter Ochieng',
    customerPhone: '254734567890',
    customerId: '3',
    loanAmount: 20000,
    loanTerm: 30,
    creditScore: 450,
    riskFlags: ['New customer', 'High loan-to-limit ratio'],
    submittedAt: '2024-12-20T10:30:00',
    kycStatus: 'VERIFIED',
  },
  {
    id: 'APP-2024-002',
    customerName: 'Sarah Njeri',
    customerPhone: '254767890123',
    customerId: '6',
    loanAmount: 50000,
    loanTerm: 60,
    creditScore: 380,
    riskFlags: ['Max loan amount', 'First time borrower'],
    submittedAt: '2024-12-20T09:15:00',
    kycStatus: 'VERIFIED',
  },
];

const mockSupportTickets = [
  {
    id: 'TKT-2024-001',
    customerName: 'John Kamau',
    customerPhone: '254712345678',
    subject: 'Repayment not reflecting',
    category: 'Payment Issue',
    priority: 'HIGH',
    status: 'OPEN',
    createdAt: '2024-12-20T08:00:00',
    lastReplyAt: '2024-12-20T08:00:00',
  },
  {
    id: 'TKT-2024-002',
    customerName: 'Mary Wanjiku',
    customerPhone: '254723456789',
    subject: 'Loan application declined unfairly',
    category: 'Credit Decision',
    priority: 'MEDIUM',
    status: 'IN_PROGRESS',
    createdAt: '2024-12-19T14:30:00',
    lastReplyAt: '2024-12-19T16:45:00',
  },
  {
    id: 'TKT-2024-003',
    customerName: 'Grace Akinyi',
    customerPhone: '254745678901',
    subject: 'Account suspended without notice',
    category: 'Account Access',
    priority: 'HIGH',
    status: 'OPEN',
    createdAt: '2024-12-20T11:00:00',
    lastReplyAt: '2024-12-20T11:00:00',
  },
];

const mockAuditLogs = [
  {
    id: 'AUD-001',
    adminId: 'admin-1',
    adminName: 'Admin User',
    action: 'LOAN_MANUALLY_APPROVED',
    entityType: 'Loan',
    entityId: 'LN-2024-003',
    description: 'Manually approved loan for Grace Akinyi',
    ipAddress: '192.168.1.100',
    createdAt: '2024-12-20T10:45:00',
  },
  {
    id: 'AUD-002',
    adminId: 'admin-1',
    adminName: 'Admin User',
    action: 'CUSTOMER_SUSPENDED',
    entityType: 'User',
    entityId: '5',
    description: 'Suspended James Mwangi for fraud risk',
    ipAddress: '192.168.1.100',
    createdAt: '2024-12-19T15:30:00',
  },
  {
    id: 'AUD-003',
    adminId: 'admin-2',
    adminName: 'Credit Manager',
    action: 'CREDIT_RULES_UPDATED',
    entityType: 'CreditRules',
    entityId: 'default',
    description: 'Updated max loan amount from 40000 to 50000',
    ipAddress: '192.168.1.101',
    createdAt: '2024-12-18T09:00:00',
  },
];

const mockSuspiciousActivity = [
  {
    id: 'SUS-001',
    customerName: 'James Mwangi',
    customerPhone: '254756789012',
    customerId: '5',
    type: 'Multiple Failed Logins',
    riskScore: 85,
    details: '5 failed login attempts in 10 minutes',
    detectedAt: '2024-12-20T11:30:00',
    status: 'UNDER_REVIEW',
  },
  {
    id: 'SUS-002',
    customerName: 'Unknown',
    customerPhone: '254799999999',
    customerId: null,
    type: 'Velocity Check Failed',
    riskScore: 92,
    details: '3 loan applications from same device in 1 hour',
    detectedAt: '2024-12-20T09:00:00',
    status: 'BLOCKED',
  },
];

const priorityOptions = { HIGH: 'badge-danger', MEDIUM: 'badge-warning', LOW: 'badge-info' };
const statusOptions = { OPEN: 'badge-info', IN_PROGRESS: 'badge-warning', RESOLVED: 'badge-success', CLOSED: 'badge-gray' };
const riskStatusOptions = { UNDER_REVIEW: 'badge-warning', BLOCKED: 'badge-danger', RESOLVED: 'badge-success', FALSE_POSITIVE: 'badge-gray' };

export default function OperationsPage() {
  const [activeTab, setActiveTab] = useState<'reviews' | 'support' | 'audit' | 'fraud'>('reviews');
  const [expandedReview, setExpandedReview] = useState<string | null>(null);

  const tabs = [
    { id: 'reviews', label: 'Manual Review', icon: FileText, count: mockPendingReviews.length },
    { id: 'support', label: 'Customer Support', icon: MessageSquare, count: mockSupportTickets.length },
    { id: 'audit', label: 'Audit Logs', icon: Shield, count: mockAuditLogs.length },
    { id: 'fraud', label: 'Fraud Monitoring', icon: Flag, count: mockSuspiciousActivity.length },
  ];

  const getPriorityBadge = (priority: string) => priorityOptions[priority as keyof typeof priorityOptions] || 'badge-gray';
  const getStatusBadge = (status: string) => statusOptions[status as keyof typeof statusOptions] || 'badge-gray';
  const getRiskStatusBadge = (status: string) => riskStatusOptions[status as keyof typeof riskStatusOptions] || 'badge-gray';

  const formatPhone = (phone: string) => {
    if (phone.startsWith('254')) {
      return `+254 ${phone.slice(3, 6)} ${phone.slice(6, 9)} ${phone.slice(9)}`;
    }
    return phone;
  };

  const handleApprove = (id: string) => {
    // TODO: Call API to approve
    alert(`Approved ${id}`);
  };

  const handleDecline = (id: string, reason: string) => {
    // TODO: Call API to decline
    alert(`Declined ${id}: ${reason}`);
  };

  const handleSuspend = (customerId: string) => {
    // TODO: Call API to suspend
    alert(`Suspended ${customerId}`);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Operations</h1>
          <p className="text-gray-500 mt-1">Manual review, customer support, audit trails, and fraud monitoring</p>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="card overflow-hidden">
        <div className="border-b border-gray-200">
          <nav className="flex -mb-px" aria-label="Operations tabs">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id as any)}
                className={clsx(
                  'flex items-center gap-2 px-4 py-3 text-sm font-medium border-b-2 transition-colors',
                  activeTab === tab.id
                    ? 'border-primary-600 text-primary-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                )}
              >
                <tab.icon className="w-4 h-4" />
                {tab.label}
                {tab.count > 0 && (
                  <span className="ml-1 px-2 py-0.5 text-xs font-medium bg-gray-100 rounded-full">
                    {tab.count}
                  </span>
                )}
              </button>
            ))}
          </nav>
        </div>

        {/* Manual Review Tab */}
        {activeTab === 'reviews' && (
          <div className="p-4 space-y-4">
            {mockPendingReviews.length === 0 ? (
              <div className="text-center py-12">
                <CheckCircle className="w-12 h-12 text-green-500 mx-auto mb-4" />
                <h3 className="text-lg font-medium text-gray-900">No Pending Reviews</h3>
                <p className="text-gray-500 mt-1">All loan applications have been processed</p>
              </div>
            ) : (
              mockPendingReviews.map((review) => (
                <div key={review.id} className="card p-4 border-l-4 border-yellow-500 bg-yellow-50">
                  <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-3 flex-wrap">
                        <span className="font-mono font-medium text-gray-900">{review.id}</span>
                        <span className="badge badge-warning">PENDING REVIEW</span>
                        <span className="badge badge-success">KYC Verified</span>
                      </div>
                      <div className="mt-2 flex flex-wrap gap-4 text-sm text-gray-600">
                        <span>{review.customerName} • {formatPhone(review.customerPhone)}</span>
                        <span>KES {review.loanAmount.toLocaleString()} • {review.loanTerm} days</span>
                        <span>Credit Score: {review.creditScore}</span>
                      </div>
                      {review.riskFlags.length > 0 && (
                        <div className="mt-2 flex flex-wrap gap-2">
                          {review.riskFlags.map((flag, i) => (
                            <span key={i} className="badge badge-warning">
                              <AlertTriangle className="w-3 h-3 mr-1" />
                              {flag}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                    <div className="flex items-center gap-3">
                      <button
                        onClick={() => setExpandedReview(expandedReview === review.id ? null : review.id)}
                        className="btn-secondary text-sm"
                      >
                        <Eye className="w-4 h-4 mr-1" /> Details
                      </button>
                      <button
                        onClick={() => handleApprove(review.id)}
                        className="btn-primary text-sm"
                      >
                        <CheckCircle className="w-4 h-4 mr-1" /> Approve
                      </button>
                      <button
                        onClick={() => handleDecline(review.id, 'Manual review decline')}
                        className="btn-secondary text-sm text-red-600 border-red-300 hover:bg-red-50"
                      >
                        <XCircle className="w-4 h-4 mr-1" /> Decline
                      </button>
                    </div>
                  </div>

                  {/* Expanded details */}
                  {expandedReview === review.id && (
                    <div className="mt-4 pt-4 border-t border-gray-200 grid grid-cols-1 md:grid-cols-3 gap-4">
                      <div>
                        <p className="text-sm font-medium text-gray-500">Customer ID</p>
                        <p className="font-medium">{review.customerId}</p>
                      </div>
                      <div>
                        <p className="text-sm font-medium text-gray-500">Submitted</p>
                        <p className="font-medium">{format(new Date(review.submittedAt), 'dd MMM yyyy HH:mm')}</p>
                      </div>
                      <div>
                        <p className="text-sm font-medium text-gray-500">Total Payable (est.)</p>
                        <p className="font-medium text-primary-700">KES {(review.loanAmount + Math.round(review.loanAmount * 0.15 * (review.loanTerm / 365)) + Math.round(review.loanAmount * 0.05)).toLocaleString()}</p>
                      </div>
                    </div>
                  )}
                </div>
              ))
            )}
          </div>
        )}

        {/* Customer Support Tab */}
        {activeTab === 'support' && (
          <div className="p-4 space-y-4">
            <div className="table-container">
              <table className="table">
                <thead>
                  <tr>
                    <th>Ticket ID</th>
                    <th>Customer</th>
                    <th>Subject</th>
                    <th>Category</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th className="w-24">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {mockSupportTickets.map((ticket) => (
                    <tr key={ticket.id} className="hover:bg-gray-50">
                      <td className="font-mono text-sm">{ticket.id}</td>
                      <td>
                        <div>
                          <p className="font-medium">{ticket.customerName}</p>
                          <p className="text-xs text-gray-500">{formatPhone(ticket.customerPhone)}</p>
                        </div>
                      </td>
                      <td className="font-medium">{ticket.subject}</td>
                      <td><span className="badge badge-gray">{ticket.category}</span></td>
                      <td><span className={clsx('badge', getPriorityBadge(ticket.priority))}>{ticket.priority}</span></td>
                      <td><span className={clsx('badge', getStatusBadge(ticket.status))}>{ticket.status.replace('_', ' ')}</span></td>
                      <td className="text-gray-600">{format(new Date(ticket.createdAt), 'dd MMM HH:mm')}</td>
                      <td>
                        <div className="flex items-center gap-2">
                          <button className="p-2 rounded-lg hover:bg-gray-100" aria-label="View ticket"><Eye className="w-4 h-4" /></button>
                          <button className="p-2 rounded-lg hover:bg-gray-100" aria-label="Reply"><Mail className="w-4 h-4" /></button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Audit Logs Tab */}
        {activeTab === 'audit' && (
          <div className="p-4 space-y-4">
            <div className="table-container">
              <table className="table">
                <thead>
                  <tr>
                    <th>Log ID</th>
                    <th>Action</th>
                    <th>Entity</th>
                    <th>Admin</th>
                    <th>Description</th>
                    <th>IP Address</th>
                    <th>Timestamp</th>
                  </tr>
                </thead>
                <tbody>
                  {mockAuditLogs.map((log) => (
                    <tr key={log.id} className="hover:bg-gray-50">
                      <td className="font-mono text-sm">{log.id}</td>
                      <td>
                        <span className="badge badge-gray">{log.action.replace(/_/g, ' ')}</span>
                      </td>
                      <td className="font-mono text-sm">{log.entityType}: {log.entityId}</td>
                      <td>{log.adminName}</td>
                      <td className="text-gray-600 max-w-xs truncate">{log.description}</td>
                      <td className="font-mono text-sm">{log.ipAddress}</td>
                      <td className="text-gray-600">{format(new Date(log.createdAt), 'dd MMM yyyy HH:mm')}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Fraud Monitoring Tab */}
        {activeTab === 'fraud' && (
          <div className="p-4 space-y-4">
            {mockSuspiciousActivity.length === 0 ? (
              <div className="text-center py-12">
                <Shield className="w-12 h-12 text-green-500 mx-auto mb-4" />
                <h3 className="text-lg font-medium text-gray-900">No Suspicious Activity</h3>
                <p className="text-gray-500 mt-1">All systems clear</p>
              </div>
            ) : (
              mockSuspiciousActivity.map((activity) => (
                <div key={activity.id} className="card p-4 border-l-4 border-red-500 bg-red-50">
                  <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-3 flex-wrap">
                        <span className="font-mono font-medium text-gray-900">{activity.id}</span>
                        <span className="badge badge-danger">{activity.type}</span>
                        <span className={clsx('badge', getRiskStatusBadge(activity.status))}>{activity.status.replace('_', ' ')}</span>
                      </div>
                      <div className="mt-2 flex flex-wrap gap-4 text-sm text-gray-600">
                        {activity.customerName && <span>{activity.customerName} • {formatPhone(activity.customerPhone)}</span>}
                        <span>Risk Score: <strong className={activity.riskScore > 80 ? 'text-red-600' : 'text-yellow-600'}>{activity.riskScore}/100</strong></span>
                      </div>
                      <p className="mt-1 text-sm text-gray-700">{activity.details}</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <button className="btn-secondary text-sm"><Eye className="w-4 h-4 mr-1" /> Investigate</button>
                      {activity.status === 'UNDER_REVIEW' && (
                        <>
                          <button className="btn-primary text-sm" onClick={() => handleSuspend(activity.customerId || '')}>
                            <Ban className="w-4 h-4 mr-1" /> Block User
                          </button>
                          <button className="btn-secondary text-sm text-green-600 border-green-300 hover:bg-green-50">
                            <CheckCircle className="w-4 h-4 mr-1" /> Mark Safe
                          </button>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        )}
      </div>
    </div>
  );
}