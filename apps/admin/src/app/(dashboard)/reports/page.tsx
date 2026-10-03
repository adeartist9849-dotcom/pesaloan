'use client';

import { useState } from 'react';
import {
  Download,
  Calendar,
  TrendingUp,
  TrendingDown,
  DollarSign,
  Users,
  CreditCard,
  Clock,
  AlertTriangle,
  CheckCircle,
  BarChart3,
  PieChart,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import clsx from 'clsx';
import { format, subDays, startOfDay, endOfDay } from 'date-fns';

const dateRanges = [
  { value: 'TODAY', label: 'Today' },
  { value: 'LAST_7_DAYS', label: 'Last 7 Days' },
  { value: 'LAST_30_DAYS', label: 'Last 30 Days' },
  { value: 'LAST_90_DAYS', label: 'Last 90 Days' },
  { value: 'THIS_MONTH', label: 'This Month' },
  { value: 'LAST_MONTH', label: 'Last Month' },
  { value: 'CUSTOM', label: 'Custom Range' },
];

const kpiData = [
  {
    id: 'total_customers',
    label: 'Total Customers',
    value: '12,345',
    change: '+12.5%',
    trend: 'up',
    icon: Users,
    color: 'bg-blue-500',
  },
  {
    id: 'active_loans',
    label: 'Active Loans',
    value: '3,421',
    change: '+8.2%',
    trend: 'up',
    icon: CreditCard,
    color: 'bg-green-500',
  },
  {
    id: 'total_disbursed',
    label: 'Total Disbursed',
    value: 'KES 45.2M',
    change: '+15.3%',
    trend: 'up',
    icon: DollarSign,
    color: 'bg-primary-600',
  },
  {
    id: 'repayment_rate',
    label: 'Repayment Rate',
    value: '94.2%',
    change: '-0.5%',
    trend: 'down',
    icon: TrendingUp,
    color: 'bg-purple-500',
  },
  {
    id: 'avg_loan_size',
    label: 'Avg Loan Size',
    value: 'KES 13,200',
    change: '+3.1%',
    trend: 'up',
    icon: CreditCard,
    color: 'bg-orange-500',
  },
  {
    id: 'overdue_rate',
    label: 'Overdue Rate',
    value: '3.8%',
    change: '+0.2%',
    trend: 'down',
    icon: AlertTriangle,
    color: 'bg-red-500',
  },
  {
    id: 'kyc_completion',
    label: 'KYC Completion',
    value: '87.4%',
    change: '+2.1%',
    trend: 'up',
    icon: CheckCircle,
    color: 'bg-teal-500',
  },
  {
    id: 'avg_processing_time',
    label: 'Avg Processing Time',
    value: '4.2 min',
    change: '-0.8 min',
    trend: 'up',
    icon: Clock,
    color: 'bg-indigo-500',
  },
];

const loanStatusData = [
  { name: 'Active', value: 3421, color: '#16a34a' },
  { name: 'Paid', value: 8932, color: '#22c55e' },
  { name: 'Overdue', value: 567, color: '#dc2626' },
  { name: 'Pending', value: 234, color: '#f59e0b' },
  { name: 'Declined', value: 1234, color: '#64748b' },
];

const monthlyTrends = [
  { month: 'Jul', disbursed: 12.5, repaid: 10.2, newCustomers: 450, activeLoans: 2100 },
  { month: 'Aug', disbursed: 15.3, repaid: 12.8, newCustomers: 520, activeLoans: 2340 },
  { month: 'Sep', disbursed: 18.7, repaid: 15.1, newCustomers: 610, activeLoans: 2680 },
  { month: 'Oct', disbursed: 22.1, repaid: 18.9, newCustomers: 580, activeLoans: 2950 },
  { month: 'Nov', disbursed: 28.4, repaid: 24.2, newCustomers: 720, activeLoans: 3180 },
  { month: 'Dec', disbursed: 32.6, repaid: 28.7, newCustomers: 690, activeLoans: 3421 },
];

const kycFunnelData = [
  { stage: 'Registered', count: 14200, percentage: 100 },
  { stage: 'KYC Started', count: 13100, percentage: 92.3 },
  { stage: 'Submitted', count: 12500, percentage: 88.0 },
  { stage: 'Under Review', count: 12100, percentage: 85.2 },
  { stage: 'Verified', count: 12400, percentage: 87.4 },
];

const topPerformingLoans = [
  { segment: 'KES 1,000 - 5,000', count: 4200, repaymentRate: 96.2, avgSize: 3200 },
  { segment: 'KES 5,001 - 10,000', count: 3800, repaymentRate: 94.8, avgSize: 7500 },
  { segment: 'KES 10,001 - 20,000', count: 2100, repaymentRate: 92.1, avgSize: 14500 },
  { segment: 'KES 20,001 - 30,000', count: 850, repaymentRate: 89.5, avgSize: 24800 },
  { segment: 'KES 30,001 - 50,000', count: 421, repaymentRate: 87.3, avgSize: 38200 },
];

export default function ReportsPage() {
  const [dateRange, setDateRange] = useState('LAST_30_DAYS');
  const [customStart, setCustomStart] = useState(format(subDays(new Date(), 30), 'yyyy-MM-dd'));
  const [customEnd, setCustomEnd] = useState(format(new Date(), 'yyyy-MM-dd'));

  const formatCurrency = (value: number) => {
    if (value >= 1e9) return `KES ${(value / 1e9).toFixed(1)}B`;
    if (value >= 1e6) return `KES ${(value / 1e6).toFixed(1)}M`;
    if (value >= 1e3) return `KES ${(value / 1e3).toFixed(0)}K`;
    return `KES ${value.toLocaleString()}`;
  };

  const renderBarChart = (data: typeof monthlyTrends, key: keyof typeof monthlyTrends[0], color: string, maxValue: number) => (
    <div className="space-y-3">
      {data.map((item) => (
        <div key={item.month} className="flex items-center gap-3">
          <span className="w-16 text-sm font-medium text-gray-600">{item.month}</span>
          <div className="flex-1 h-4 bg-gray-100 rounded-full overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-500"
              style={{ width: `${(item[key] as number / maxValue) * 100}%`, backgroundColor: color }}
            />
          </div>
          <span className="w-24 text-right text-sm font-medium text-gray-900">
            {typeof item[key] === 'number' && (key === 'disbursed' || key === 'repaid') 
              ? formatCurrency(item[key] * 1e6) 
              : (item[key] as number).toLocaleString()}
          </span>
        </div>
      ))}
    </div>
  );

  const renderFunnel = () => (
    <div className="space-y-3">
      {kycFunnelData.map((item) => (
        <div key={item.stage} className="flex items-center gap-3">
          <span className="w-32 text-sm font-medium text-gray-600">{item.stage}</span>
          <div className="flex-1 h-8 bg-gray-100 rounded-full overflow-hidden relative">
            <div
              className="h-full rounded-full bg-primary-600 transition-all duration-500 flex items-center justify-end pr-3"
              style={{ width: `${item.percentage}%` }}
            >
              <span className="text-xs font-medium text-white">{item.count.toLocaleString()} ({item.percentage}%)</span>
            </div>
          </div>
        </div>
      ))}
    </div>
  );

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Reports & Analytics</h1>
          <p className="text-gray-500 mt-1">Business intelligence and performance metrics</p>
        </div>
        <div className="flex items-center gap-3">
          <div className="relative">
            <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <select
              value={dateRange}
              onChange={(e) => setDateRange(e.target.value)}
              className="input-field pl-10 w-auto"
            >
              {dateRanges.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
            </select>
          </div>
          {dateRange === 'CUSTOM' && (
            <div className="flex items-center gap-2">
              <input
                type="date"
                value={customStart}
                onChange={(e) => setCustomStart(e.target.value)}
                className="input-field w-auto"
                max={customEnd}
              />
              <span className="text-gray-400">to</span>
              <input
                type="date"
                value={customEnd}
                onChange={(e) => setCustomEnd(e.target.value)}
                className="input-field w-auto"
                min={customStart}
                max={format(new Date(), 'yyyy-MM-dd')}
              />
            </div>
          )}
          <button className="btn-secondary">
            <Download className="w-4 h-4 mr-2" />
            Export Report
          </button>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 xl:grid-cols-8 gap-4">
        {kpiData.map((kpi) => (
          <div key={kpi.id} className="card p-4 xl:col-span-2 lg:col-span-1">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">{kpi.label}</p>
                <p className="text-2xl font-bold text-gray-900 mt-1">{kpi.value}</p>
              </div>
              <div className={kpi.color + ' p-3 rounded-xl'}>
                <kpi.icon className="w-6 h-6 text-white" />
              </div>
            </div>
            <div className="mt-4 flex items-center gap-2">
              <span className={kpi.trend === 'up' ? 'text-green-600' : 'text-red-600'}>
                {kpi.trend === 'up' ? '↑' : '↓'} {kpi.change}
              </span>
              <span className="text-sm text-gray-500">vs previous period</span>
            </div>
          </div>
        ))}
      </div>

      {/* Charts Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Monthly Trends */}
        <div className="card p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">Monthly Trends (KES Millions)</h2>
          <div className="space-y-6">
            <div>
              <div className="flex items-center gap-4 mb-4">
                <span className="flex items-center gap-1">
                  <span className="w-3 h-3 rounded-full bg-primary-600"></span>
                  <span className="text-sm font-medium">Disbursed</span>
                </span>
                <span className="flex items-center gap-1">
                  <span className="w-3 h-3 rounded-full bg-green-600"></span>
                  <span className="text-sm font-medium">Repaid</span>
                </span>
              </div>
              {renderBarChart(monthlyTrends, 'disbursed', '#2563eb', 35)}
            </div>
            <div>
              <h4 className="text-sm font-medium text-gray-500 mb-3">New Customers & Active Loans</h4>
              {renderBarChart(monthlyTrends, 'newCustomers', '#16a34a', 750)}
            </div>
          </div>
        </div>

        {/* Loan Portfolio Status */}
        <div className="card p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">Loan Portfolio Status</h2>
          <div className="space-y-4">
            {loanStatusData.map((item) => (
              <div key={item.name} className="flex items-center gap-4">
                <div className="w-20">
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
                <div className="w-24 text-right text-sm text-gray-600">
                  {item.value.toLocaleString()}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* KYC Funnel */}
        <div className="card p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">KYC Conversion Funnel</h2>
          {renderFunnel()}
        </div>

        {/* Top Performing Loan Segments */}
        <div className="card p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">Loan Segment Performance</h2>
          <div className="table-container">
            <table className="table">
              <thead>
                <tr>
                  <th>Loan Segment</th>
                  <th>Count</th>
                  <th>Avg Size</th>
                  <th>Repayment Rate</th>
                  <th>Risk Level</th>
                </tr>
              </thead>
              <tbody>
                {topPerformingLoans.map((segment) => (
                  <tr key={segment.segment} className="hover:bg-gray-50">
                    <td className="font-medium text-gray-900">{segment.segment}</td>
                    <td className="text-gray-600">{segment.count.toLocaleString()}</td>
                    <td className="font-medium text-gray-900">{formatCurrency(segment.avgSize)}</td>
                    <td>
                      <div className="flex items-center gap-2">
                        <div className="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                          <div
                            className="h-full rounded-full bg-green-500"
                            style={{ width: `${segment.repaymentRate}%` }}
                          />
                        </div>
                        <span className="text-sm font-medium text-green-700">{segment.repaymentRate}%</span>
                      </div>
                    </td>
                    <td>
                      <span className={clsx('badge', 
                        segment.repaymentRate >= 95 ? 'badge-success' :
                        segment.repaymentRate >= 90 ? 'badge-warning' :
                        'badge-danger'
                      )}>
                        {segment.repaymentRate >= 95 ? 'Low' : segment.repaymentRate >= 90 ? 'Medium' : 'High'}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Additional Metrics Row */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="card p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Key Ratios</h2>
          <div className="grid grid-cols-2 gap-4">
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm text-gray-500">NPL Ratio</p>
              <p className="text-2xl font-bold text-red-600">3.8%</p>
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm text-gray-500">Coverage Ratio</p>
              <p className="text-2xl font-bold text-green-600">142%</p>
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm text-gray-500">Cost of Risk</p>
              <p className="text-2xl font-bold text-orange-600">2.1%</p>
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm text-gray-500">Yield on Portfolio</p>
              <p className="text-2xl font-bold text-primary-600">18.5%</p>
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm text-gray-500">ROA</p>
              <p className="text-2xl font-bold text-blue-600">4.2%</p>
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm text-gray-500">ROE</p>
              <p className="text-2xl font-bold text-purple-600">22.8%</p>
            </div>
          </div>
        </div>

        <div className="card p-6 lg:col-span-2">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Repayment Calendar (Next 30 Days)</h2>
          <div className="table-container">
            <table className="table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Expected Repayments</th>
                  <th>Amount (KES)</th>
                  <th>Active Loans Due</th>
                  <th>Collection Rate (Est.)</th>
                </tr>
              </thead>
              <tbody>
                {Array.from({ length: 14 }, (_, i) => {
                  const date = subDays(new Date(), -i);
                  const isWeekend = date.getDay() === 0 || date.getDay() === 6;
                  return (
                    <tr key={i} className={clsx('hover:bg-gray-50', isWeekend && 'bg-gray-50')}>
                      <td className={clsx('font-medium', isWeekend && 'text-gray-400')}>
                        {format(date, 'EEE, dd MMM')}
                        {isWeekend && <span className="ml-2 badge badge-gray">Weekend</span>}
                      </td>
                      <td>{Math.floor(Math.random() * 200) + 50}</td>
                      <td className="font-medium">{formatCurrency(Math.floor(Math.random() * 2000000) + 500000)}</td>
                      <td>{Math.floor(Math.random() * 150) + 30}</td>
                      <td>
                        <span className="badge badge-success">{94 + Math.floor(Math.random() * 4)}%</span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}