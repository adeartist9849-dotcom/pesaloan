'use client';

import { useState } from 'react';
import { Save, Loader2, AlertCircle, CheckCircle, XCircle, CreditCard, Building2, Smartphone } from 'lucide-react';
import clsx from 'clsx';

interface RegistrationFee {
  id: string;
  amount: number;
  currency: string;
  isActive: boolean;
  description?: string;
  destinationType: 'MPESA_TILL' | 'MPESA_PAYBILL' | 'BANK_ACCOUNT' | 'MOBILE_MONEY';
  destinationAccount: string;
  destinationName?: string;
  destinationBranch?: string;
  destinationReference?: string;
  createdAt: string;
  updatedAt: string;
}

const destinationTypeOptions = [
  { value: 'MPESA_TILL', label: 'M-Pesa Till Number', icon: Smartphone },
  { value: 'MPESA_PAYBILL', label: 'M-Pesa Paybill', icon: Smartphone },
  { value: 'BANK_ACCOUNT', label: 'Bank Account', icon: Building2 },
  { value: 'MOBILE_MONEY', label: 'Mobile Money (Other)', icon: CreditCard },
];

export default function RegistrationFeePage() {
  const [fee, setFee] = useState<RegistrationFee | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  
  const [formData, setFormData] = useState({
    amount: '',
    currency: 'KES',
    isActive: true,
    description: '',
    destinationType: 'MPESA_TILL' as 'MPESA_TILL' | 'MPESA_PAYBILL' | 'BANK_ACCOUNT' | 'MOBILE_MONEY',
    destinationAccount: '',
    destinationName: '',
    destinationBranch: '',
    destinationReference: '',
  });

  const fetchFee = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/admin/registration-fee');
      if (response.ok) {
        const data = await response.json();
        setFee(data);
        setFormData({
          amount: (data.amount / 100).toString(),
          currency: data.currency,
          isActive: data.isActive,
          description: data.description || '',
          destinationType: data.destinationType || 'MPESA_TILL',
          destinationAccount: data.destinationAccount || '',
          destinationName: data.destinationName || '',
          destinationBranch: data.destinationBranch || '',
          destinationReference: data.destinationReference || '',
        });
      } else if (response.status === 404) {
        // No fee configured yet
        setFee(null);
      } else {
        setError('Failed to load registration fee');
      }
    } catch {
      setError('Failed to load registration fee');
    } finally {
      setLoading(false);
    }
  };

  const saveFee = async () => {
    if (!formData.amount || Number(formData.amount) <= 0) {
      setError('Please enter a valid amount');
      return;
    }
    if (!formData.destinationAccount) {
      setError('Destination account is required');
      return;
    }

    setSaving(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch('/api/admin/registration-fee', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          amount: Math.round(Number(formData.amount) * 100), // Convert to cents
          currency: formData.currency,
          isActive: formData.isActive,
          description: formData.description,
          destinationType: formData.destinationType,
          destinationAccount: formData.destinationAccount,
          destinationName: formData.destinationName,
          destinationBranch: formData.destinationBranch,
          destinationReference: formData.destinationReference,
        }),
      });

      if (response.ok) {
        const data = await response.json();
        setFee(data);
        setFormData({
          amount: (data.amount / 100).toString(),
          currency: data.currency,
          isActive: data.isActive,
          description: data.description || '',
          destinationType: data.destinationType,
          destinationAccount: data.destinationAccount,
          destinationName: data.destinationName || '',
          destinationBranch: data.destinationBranch || '',
          destinationReference: data.destinationReference || '',
        });
        setSuccess('Registration fee updated successfully');
      } else {
        const errorData = await response.json();
        setError(errorData.message || 'Failed to save registration fee');
      }
    } catch {
      setError('Failed to save registration fee');
    } finally {
      setSaving(false);
    }
  };

  const formatAmount = (amount: number) => {
    return new Intl.NumberFormat('en-KE', {
      style: 'currency',
      currency: 'KES',
      minimumFractionDigits: 2,
    }).format(amount / 100);
  };

  const getDestinationTypeLabel = (type: string) => {
    return destinationTypeOptions.find(opt => opt.value === type)?.label || type;
  };

  const getDestinationTypeIcon = (type: string) => {
    const opt = destinationTypeOptions.find(o => o.value === type);
    return opt ? opt.icon : CreditCard;
  };

  const DestinationTypeIcon = getDestinationTypeIcon(formData.destinationType);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Registration Fee</h1>
          <p className="text-gray-500 mt-1">Manage the one-time registration fee for new users</p>
        </div>
      </div>

      {/* Current Fee */}
      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Current Configuration</h2>
        
        {loading ? (
          <div className="flex items-center justify-center py-8">
            <Loader2 className="w-8 h-8 animate-spin text-primary-600" />
            <span className="ml-3 text-gray-600">Loading...</span>
          </div>
        ) : fee ? (
          <div className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
              <div className="bg-primary-50 rounded-lg p-4">
                <p className="text-sm text-gray-500">Fee Amount</p>
                <p className="text-3xl font-bold text-primary-700">{formatAmount(fee.amount)}</p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4">
                <p className="text-sm text-gray-500">Currency</p>
                <p className="text-xl font-semibold text-gray-900">{fee.currency}</p>
              </div>
              <div className={clsx('rounded-lg p-4', fee.isActive ? 'bg-green-50' : 'bg-gray-50')}>
                <p className="text-sm text-gray-500">Status</p>
                <p className={clsx('text-xl font-semibold', fee.isActive ? 'text-green-700' : 'text-gray-700')}>
                  {fee.isActive ? 'Active' : 'Inactive'}
                </p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4">
                <p className="text-sm text-gray-500">Last Updated</p>
                <p className="text-lg font-medium text-gray-900">
                  {new Date(fee.updatedAt).toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                  })}
                </p>
              </div>
            </div>

            {/* Destination Info */}
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <div className="flex items-center gap-3 mb-3">
                <DestinationTypeIcon className="w-6 h-6 text-blue-600" />
                <h3 className="font-semibold text-blue-900">Payment Destination</h3>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                <div>
                  <p className="text-blue-600">Type</p>
                  <p className="font-medium text-blue-900">{getDestinationTypeLabel(fee.destinationType)}</p>
                </div>
                <div>
                  <p className="text-blue-600">Account / Till / Paybill</p>
                  <p className="font-medium text-blue-900 font-mono">{fee.destinationAccount}</p>
                </div>
                {fee.destinationName && (
                  <div>
                    <p className="text-blue-600">Name</p>
                    <p className="font-medium text-blue-900">{fee.destinationName}</p>
                  </div>
                )}
                {fee.destinationBranch && (
                  <div>
                    <p className="text-blue-600">Branch</p>
                    <p className="font-medium text-blue-900">{fee.destinationBranch}</p>
                  </div>
                )}
                {fee.destinationReference && (
                  <div>
                    <p className="text-blue-600">Reference</p>
                    <p className="font-medium text-blue-900">{fee.destinationReference}</p>
                  </div>
                )}
              </div>
            </div>
          </div>
        ) : (
          <div className="text-center py-8">
            <AlertCircle className="w-12 h-12 text-gray-400 mx-auto mb-3" />
            <p className="text-gray-600">No registration fee configured yet</p>
          </div>
        )}

        {fee?.description && (
          <div className="mt-4 p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-500">Description</p>
            <p className="text-gray-900">{fee.description}</p>
          </div>
        )}
      </div>

      {/* Update Fee Form */}
      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Update Registration Fee</h2>
        
        {(error || success) && (
          <div 
            className={clsx('mb-4 p-4 rounded-lg flex items-center gap-3', 
              error ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'
            )}
            role="alert"
          >
            {error ? (
              <>
                <AlertCircle className="w-5 h-5 flex-shrink-0" />
                <span>{error}</span>
              </>
            ) : (
              <>
                <CheckCircle className="w-5 h-5 flex-shrink-0" />
                <span>{success}</span>
              </>
            )}
          </div>
        )}

        <div className="space-y-4">
          <div>
            <label htmlFor="amount" className="block text-sm font-medium text-gray-700 mb-1">
              Fee Amount <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500">KES</span>
              <input
                type="number"
                id="amount"
                value={formData.amount}
                onChange={(e) => setFormData(prev => ({ ...prev, amount: e.target.value }))}
                placeholder="e.g., 100"
                min="1"
                step="0.01"
                className="input-field pl-10"
                required
              />
            </div>
            <p className="text-xs text-gray-500 mt-1">Amount in KES (will be stored in cents)</p>
          </div>

          <div>
            <label htmlFor="currency" className="block text-sm font-medium text-gray-700 mb-1">
              Currency
            </label>
            <select
              id="currency"
              value={formData.currency}
              onChange={(e) => setFormData(prev => ({ ...prev, currency: e.target.value }))}
              className="input-field"
            >
              <option value="KES">KES - Kenyan Shilling</option>
            </select>
          </div>

          <div>
            <label htmlFor="description" className="block text-sm font-medium text-gray-700 mb-1">
              Description (Optional)
            </label>
            <textarea
              id="description"
              value={formData.description}
              onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
              rows={3}
              placeholder="e.g., One-time account activation fee"
              className="input-field"
            />
          </div>

          {/* Payment Destination Section */}
          <div className="border-t border-gray-200 pt-4">
            <h3 className="text-md font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <CreditCard className="w-5 h-5 text-primary-600" />
              Payment Destination
            </h3>
            <p className="text-sm text-gray-500 mb-4">
              Configure where the registration fee money will be sent. This determines the M-Pesa Till/Paybill or Bank Account that receives the payments.
            </p>

            <div>
              <label htmlFor="destinationType" className="block text-sm font-medium text-gray-700 mb-1">
                Destination Type <span className="text-red-500">*</span>
              </label>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                {destinationTypeOptions.map((opt) => {
                  const Icon = opt.icon;
                  const isSelected = formData.destinationType === opt.value;
                  return (
                    <button
                      key={opt.value}
                      type="button"
                      onClick={() => setFormData(prev => ({ ...prev, destinationType: opt.value as any }))}
                      className={clsx(
                        'p-3 rounded-lg border-2 text-center transition-all',
                        isSelected
                          ? 'border-primary-600 bg-primary-50 text-primary-700'
                          : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50 text-gray-600'
                      )}
                    >
                      <Icon className={clsx('w-5 h-5 mx-auto mb-2', isSelected ? 'text-primary-600' : 'text-gray-400')} />
                      <span className="text-sm font-medium">{opt.label}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            <div>
              <label htmlFor="destinationAccount" className="block text-sm font-medium text-gray-700 mb-1">
                {formData.destinationType === 'MPESA_TILL' && 'Till Number'}
                {formData.destinationType === 'MPESA_PAYBILL' && 'Paybill Number'}
                {formData.destinationType === 'BANK_ACCOUNT' && 'Bank Account Number'}
                {formData.destinationType === 'MOBILE_MONEY' && 'Mobile Money Account'}
                <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                id="destinationAccount"
                value={formData.destinationAccount}
                onChange={(e) => setFormData(prev => ({ ...prev, destinationAccount: e.target.value }))}
                placeholder={
                  formData.destinationType === 'MPESA_TILL' ? 'e.g., 1234567' :
                  formData.destinationType === 'MPESA_PAYBILL' ? 'e.g., 123456' :
                  formData.destinationType === 'BANK_ACCOUNT' ? 'e.g., 0123456789' :
                  'e.g., account identifier'
                }
                className="input-field"
                required
              />
              <p className="text-xs text-gray-500 mt-1">
                {formData.destinationType === 'MPESA_TILL' && 'M-Pesa Till Number (usually 7 digits)'}
                {formData.destinationType === 'MPESA_PAYBILL' && 'M-Pesa Paybill Number (usually 6 digits)'}
                {formData.destinationType === 'BANK_ACCOUNT' && 'Bank account number'}
                {formData.destinationType === 'MOBILE_MONEY' && 'Mobile money account identifier'}
              </p>
            </div>

            <div>
              <label htmlFor="destinationName" className="block text-sm font-medium text-gray-700 mb-1">
                Destination Name (Optional)
              </label>
              <input
                type="text"
                id="destinationName"
                value={formData.destinationName}
                onChange={(e) => setFormData(prev => ({ ...prev, destinationName: e.target.value }))}
                placeholder={
                  formData.destinationType === 'MPESA_TILL' ? 'e.g., PesaLoan Main Till' :
                  formData.destinationType === 'MPESA_PAYBILL' ? 'e.g., PesaLoan Paybill' :
                  formData.destinationType === 'BANK_ACCOUNT' ? 'e.g., KCB Bank - Main Account' :
                  'e.g., Airtel Money Account'
                }
                className="input-field"
              />
              <p className="text-xs text-gray-500 mt-1">Friendly name for identification in reports</p>
            </div>

            {formData.destinationType === 'BANK_ACCOUNT' && (
              <>
                <div>
                  <label htmlFor="destinationBranch" className="block text-sm font-medium text-gray-700 mb-1">
                    Bank Branch Code (Optional)
                  </label>
                  <input
                    type="text"
                    id="destinationBranch"
                    value={formData.destinationBranch}
                    onChange={(e) => setFormData(prev => ({ ...prev, destinationBranch: e.target.value }))}
                    placeholder="e.g., 01100 (KCB Kenyatta Ave)"
                    className="input-field"
                  />
                  <p className="text-xs text-gray-500 mt-1">Bank branch/sort code</p>
                </div>

                <div>
                  <label htmlFor="destinationReference" className="block text-sm font-medium text-gray-700 mb-1">
                    Account Name / Reference (Optional)
                  </label>
                  <input
                    type="text"
                    id="destinationReference"
                    value={formData.destinationReference}
                    onChange={(e) => setFormData(prev => ({ ...prev, destinationReference: e.target.value }))}
                    placeholder="e.g., PesaLoan Limited"
                    className="input-field"
                  />
                  <p className="text-xs text-gray-500 mt-1">Account holder name for bank transfers</p>
                </div>
              </>
            )}
          </div>

          <div className="flex items-center gap-3">
            <input
              type="checkbox"
              id="isActive"
              checked={formData.isActive}
              onChange={(e) => setFormData(prev => ({ ...prev, isActive: e.target.checked }))}
              className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
            />
            <label htmlFor="isActive" className="text-sm text-gray-700">
              Active (users will be required to pay this fee)
            </label>
          </div>

          <button
            onClick={saveFee}
            disabled={saving}
            className="btn-primary w-full sm:w-auto"
          >
            {saving ? (
              <>
                <Loader2 className="w-5 h-5 animate-spin mr-2" />
                Saving...
              </>
            ) : (
              <>
                <Save className="w-5 h-5 mr-2" />
                Save Registration Fee
              </>
            )}
          </button>
        </div>
      </div>

      {/* Info */}
      <div className="card p-6 bg-blue-50 border-blue-200">
        <div className="flex gap-4">
          <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
            <span className="text-blue-600 text-lg">ℹ️</span>
          </div>
          <div>
            <h3 className="font-semibold text-blue-900">How it works</h3>
            <ul className="text-sm text-blue-800 mt-2 space-y-1 list-disc list-inside">
              <li>This fee is charged once during user registration</li>
              <li>Users must pay via M-Pesa STK Push before they can log in</li>
              <li>Only one active fee configuration can exist at a time</li>
              <li>Changing the fee will deactivate the previous one</li>
              <li>Fee amount is stored in cents (e.g., 10000 = KES 100.00)</li>
              <li><strong>Payment Destination:</strong> Choose where money goes - M-Pesa Till, Paybill, or Bank Account</li>
              <li>For M-Pesa Till/Paybill: Enter the till/paybill number as the destination account</li>
              <li>For Bank Account: Enter account number, branch code, and account name</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}