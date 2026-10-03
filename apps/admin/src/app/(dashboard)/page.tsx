'use client';

import {
  Users,
  CreditCard,
  DollarSign,
  TrendingUp,
  Clock,
  AlertTriangle,
  Shield,
} from 'lucide-react';
import { format } from 'date-fns';

const stats = [
  {
    name: 'Total Customers',
    value: '12,345',
    change: '+12.5%',
    icon: Users,
    color: 'bg-blue-500',
    trend: 'up',
  },
  {
    name: 'Active Loans',
    value: '3,421',
    change: '+8.2%',
    icon: CreditCard,
    color: 'bg-green-500',
    trend: 'up',
  },
  {
    name: 'Total Disbursed',
    value: 'KES 45.2M',
    change: '+15.3%',
    icon: DollarSign,
    color: 'bg-primary-600',
    trend: 'up',
  },
  {
    name: 'Repayment Rate',
    value: '94.2%',
    change: '-0.5%',
    icon: TrendingUp,
    color: 'bg-purple-500',
    trend: 'down',
  },
];

const recentActivity = [
  { id: 1, type: 'loan_disbursed', customer: 'John Kamau', amount: 'KES 15,000', time: '2 min ago', status: 'completed' },
  { id: 2, type: 'repayment', customer: 'Mary Wanjiku', amount: 'KES 5,000', time: '15 min ago', status: 'completed' },
  { id: 3, type: 'application', customer: 'Peter Ochieng', amount: 'KES 25,000', time: '1 hour ago', status: 'pending' },
  { id: 4, type: 'kyc_verified', customer: 'Grace Akinyi', amount: '', time: '2 hours ago', status: 'completed' },
  { id: 5, type: 'loan_overdue', customer: 'James Mwangi', amount: 'KES 8,500', time: '3 hours ago', status: 'overdue' },
];

const loanStatusData = [
  { name: 'Active', value: 3421, color: 'hsl(142, 76%, 36%)' },
  { name: 'Paid', value: 8932, color: 'hsl(142, 71%, 45%)' },
  { name: 'Overdue', value: 567, color: 'hsl(0, 84%, 60%)' },
  { name: 'Pending', value: 234, color: 'hsl(38, 92%, 50%)' },
  { name: 'Declined', value: 1234, color: 'hsl(0, 0%, 45%)' },
];

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      {/* Page header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-500 mt-1">Overview of your lending platform performance</p>
        </div>
        <div className="flex items-center gap-2">
          <select className="input-field w-auto py-1.5 text-sm">
            <option>Last 7 days</option>
            <option>Last 30 days</option>
            <option>Last 90 days</option>
          </select>
        </div>
      </div>

      {/* Stats grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {stats.map((stat) => (
          <div key={stat.name} className="card p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">{stat.name}</p>
                <p className="text-3xl font-bold text-gray-900 mt-1">{stat.value}</p>
              </div>
              <div className={stat.color + ' p-3 rounded-xl'}>
                <stat.icon className="w-6 h-6 text-white" />
              </div>
            </div>
            <div className="mt-4 flex items-center gap-2">
              <span className={stat.trend === 'up' ? 'text-green-600' : 'text-red-600'}>
                {stat.trend === 'up' ? '↑' : '↓'} {stat.change}
              </span>
              <span className="text-sm text-gray-500">vs last period</span>
            </div>
          </div>
        ))}
      </div>

      {/* Charts and activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Loan Status Chart */}
        <div className="card p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">Loan Portfolio Status</h2>
          <div className="space-y-4">
            {loanStatusData.map((item) => (
              <div key={item.name} className="flex items-center gap-4">
                <div className="w-32">
                  <span className="text-sm font-medium text-gray-700">{item.name}</span>
                </div>
                <div className="flex-1 h-3 bg-gray-100 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${(item.value / 15000) * 100}%`,
                      backgroundColor: item.color,
                    }}
                  />
                </div>
                <div className="w-20 text-right text-sm text-gray-600">
                  {item.value.toLocaleString()}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Activity */}
        <div className="card p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-900">Recent Activity</h2>
            <button className="text-sm text-primary-600 hover:text-primary-700">View all</button>
          </div>
          <div className="space-y-4">
            {recentActivity.map((activity) => (
              <div key={activity.id} className="flex items-center gap-4 p-3 bg-gray-50 rounded-lg">
                <div
                  className={`w-10 h-10 rounded-lg flex items-center justify-center ${
                    activity.status === 'completed' ? 'bg-green-100 text-green-600' :
                    activity.status === 'pending' ? 'bg-yellow-100 text-yellow-600' :
                    'bg-red-100 text-red-600'
                  }`}
                >
                  {activity.type === 'loan_disbursed' && <DollarSign className="w-5 h-5" />}
                  {activity.type === 'repayment' && <TrendingUp className="w-5 h-5" />}
                  {activity.type === 'application' && <CreditCard className="w-5 h-5" />}
                  {activity.type === 'kyc_verified' && <Users className="w-5 h-5" />}
                  {activity.type === 'loan_overdue' && <AlertTriangle className="w-5 h-5" />}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-gray-900 truncate">{activity.customer}</p>
                  <p className="text-xs text-gray-500 capitalize">{activity.type.replace('_', ' ')}</p>
                </div>
                <div className="text-right">
                  {activity.amount && (
                    <p className="text-sm font-medium text-gray-900">{activity.amount}</p>
                  )}
                  <p className="text-xs text-gray-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-left">
            <Users className="w-6 h-6 text-primary-600 mb-2" />
            <p className="font-medium text-gray-900">Add Customer</p>
            <p className="text-sm text-gray-500 mt-1">Register new borrower</p>
          </button>
          <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-left">
            <CreditCard className="w-6 h-6 text-primary-600 mb-2" />
            <p className="font-medium text-gray-900">Review Applications</p>
            <p className="text-sm text-gray-500 mt-1">23 pending review</p>
          </button>
          <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-left">
            <DollarSign className="w-6 h-6 text-primary-600 mb-2" />
            <p className="font-medium text-gray-900">Process Disbursement</p>
            <p className="text-sm text-gray-500 mt-1">5 approved loans</p>
          </button>
          <button className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-left">
            <Shield className="w-6 h-6 text-primary-600 mb-2" />
            <p className="font-medium text-gray-900">Risk Review</p>
            <p className="text-sm text-gray-500 mt-1">12 flagged accounts</p>
          </button>
        </div>
      </div>
    </div>
  );
}