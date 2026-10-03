'use client';

import { useState } from 'react';
import {
  Save,
  RefreshCw,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Info,
} from 'lucide-react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import clsx from 'clsx';

const creditRulesSchema = z.object({
  minLoanAmount: z.number().min(100, 'Minimum 100 KES').max(1000000),
  maxLoanAmount: z.number().min(1000).max(10000000),
  minTermDays: z.number().min(1).max(365),
  maxTermDays: z.number().min(7).max(365),
  interestRate: z.number().min(0).max(100, 'Max 100%'),
  processingFeeRate: z.number().min(0).max(50, 'Max 50%'),
  lateFeeRate: z.number().min(0).max(10, 'Max 10% per day'),
  maxLoanToLimitRatio: z.number().min(0.1).max(1, 'Max 100%'),
  minCreditScore: z.number().min(0).max(1000),
  maxActiveLoans: z.number().min(1).max(10),
});

type CreditRulesForm = z.infer<typeof creditRulesSchema>;

const defaultRules: CreditRulesForm = {
  minLoanAmount: 500,
  maxLoanAmount: 50000,
  minTermDays: 7,
  maxTermDays: 90,
  interestRate: 15.0,
  processingFeeRate: 5.0,
  lateFeeRate: 1.0,
  maxLoanToLimitRatio: 1.0,
  minCreditScore: 300,
  maxActiveLoans: 1,
};

interface FieldConfigItem {
  name: keyof CreditRulesForm;
  label: string;
  step: number;
  icon: string;
}

const fieldConfig: FieldConfigItem[] = [
  { name: 'minLoanAmount', label: 'Minimum Loan Amount (KES)', step: 100, icon: '💰' },
  { name: 'maxLoanAmount', label: 'Maximum Loan Amount (KES)', step: 1000, icon: '💰' },
  { name: 'minTermDays', label: 'Minimum Term (days)', step: 1, icon: '📅' },
  { name: 'maxTermDays', label: 'Maximum Term (days)', step: 1, icon: '📅' },
  { name: 'interestRate', label: 'Annual Interest Rate (%)', step: 0.1, icon: '📈' },
  { name: 'processingFeeRate', label: 'Processing Fee Rate (%)', step: 0.1, icon: '💸' },
  { name: 'lateFeeRate', label: 'Late Fee Rate (% per day)', step: 0.1, icon: '⚠️' },
  { name: 'maxLoanToLimitRatio', label: 'Max Loan-to-Limit Ratio', step: 0.05, icon: '⚖️' },
  { name: 'minCreditScore', label: 'Minimum Credit Score', step: 1, icon: '🎯' },
  { name: 'maxActiveLoans', label: 'Max Concurrent Loans', step: 1, icon: '🔢' },
];

const validationRules = [
  { field: 'minLoanAmount < maxLoanAmount', message: 'Min loan must be less than max loan' },
  { field: 'minTermDays < maxTermDays', message: 'Min term must be less than max term' },
  { field: 'interestRate > 0', message: 'Interest rate should be positive' },
  { field: 'processingFeeRate >= 0', message: 'Processing fee cannot be negative' },
  { field: 'lateFeeRate > 0', message: 'Late fee should be positive' },
  { field: 'maxLoanToLimitRatio <= 1', message: 'Loan-to-limit ratio cannot exceed 100%' },
];

export default function CreditPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [isDirty, setIsDirty] = useState(false);
  const [lastSaved, setLastSaved] = useState<Date | null>(null);
  const [validationErrors, setValidationErrors] = useState<string[]>([]);

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
  } = useForm<CreditRulesForm>({
    resolver: zodResolver(creditRulesSchema),
    defaultValues: defaultRules,
    mode: 'onChange',
  });

  const values = watch();

  const validateCrossFields = () => {
    const errs: string[] = [];
    if (values.minLoanAmount >= values.maxLoanAmount) {
      errs.push('Minimum loan amount must be less than maximum loan amount');
    }
    if (values.minTermDays >= values.maxTermDays) {
      errs.push('Minimum term must be less than maximum term');
    }
    if (values.maxLoanToLimitRatio > 1) {
      errs.push('Loan-to-limit ratio cannot exceed 100%');
    }
    setValidationErrors(errs);
    return errs.length === 0;
  };

  const onSubmit = async (data: CreditRulesForm) => {
    if (!validateCrossFields()) return;
    
    setIsLoading(true);
    try {
      // TODO: Call API to save credit rules
      await new Promise(resolve => setTimeout(resolve, 1000));
      setLastSaved(new Date());
      setIsDirty(false);
      // Show success toast
    } catch (error) {
      // Show error toast
    } finally {
      setIsLoading(false);
    }
  };

  const onChange = () => {
    setIsDirty(true);
    validateCrossFields();
  };

  const handleReset = () => {
    setValue('minLoanAmount', defaultRules.minLoanAmount);
    setValue('maxLoanAmount', defaultRules.maxLoanAmount);
    setValue('minTermDays', defaultRules.minTermDays);
    setValue('maxTermDays', defaultRules.maxTermDays);
    setValue('interestRate', defaultRules.interestRate);
    setValue('processingFeeRate', defaultRules.processingFeeRate);
    setValue('lateFeeRate', defaultRules.lateFeeRate);
    setValue('maxLoanToLimitRatio', defaultRules.maxLoanToLimitRatio);
    setValue('minCreditScore', defaultRules.minCreditScore);
    setValue('maxActiveLoans', defaultRules.maxActiveLoans);
    setIsDirty(false);
    setValidationErrors([]);
  };

  // Calculate example loan pricing
  const exampleAmount = 10000;
  const exampleTerm = 30;
  const interest = Math.round(exampleAmount * (values.interestRate / 100) * (exampleTerm / 365));
  const fees = Math.round(exampleAmount * (values.processingFeeRate / 100));
  const totalPayable = exampleAmount + interest + fees;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Credit Configuration</h1>
          <p className="text-gray-500 mt-1">Manage loan eligibility rules, pricing, and risk parameters</p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={handleReset}
            disabled={!isDirty || isLoading}
            className="btn-secondary"
          >
            <RefreshCw className="w-4 h-4 mr-2" />
            Reset to Defaults
          </button>
          <button
            onClick={handleSubmit(onSubmit)}
            disabled={!isDirty || isLoading}
            className="btn-primary"
          >
            <Save className="w-4 h-4 mr-2" />
            {isLoading ? 'Saving...' : 'Save Changes'}
          </button>
        </div>
      </div>

      {/* Status bar */}
      <div className="card p-4 bg-gray-50 border-yellow-200">
        <div className="flex items-center gap-4 flex-wrap">
          <div className="flex items-center gap-2 text-yellow-700">
            <Info className="w-5 h-5" />
            <span className="text-sm">
              Changes require <strong>Save</strong> to take effect. Test with the calculator below.
            </span>
          </div>
          {lastSaved && (
            <div className="flex items-center gap-2 text-green-700">
              <CheckCircle className="w-5 h-5" />
              <span className="text-sm">Last saved: {lastSaved.toLocaleTimeString()}</span>
            </div>
          )}
          {isDirty && !isLoading && (
            <div className="flex items-center gap-2 text-blue-700">
              <Info className="w-5 h-5" />
              <span className="text-sm">Unsaved changes</span>
            </div>
          )}
        </div>
      </div>

      {/* Validation Errors */}
      {validationErrors.length > 0 && (
        <div className="card p-4 border-red-200 bg-red-50">
          <div className="flex items-start gap-3">
            <AlertTriangle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-red-800">Validation Errors</p>
              <ul className="mt-2 space-y-1 text-sm text-red-700">
                {validationErrors.map((err, i) => (
                  <li key={i} className="flex items-center gap-2">
                    <XCircle className="w-4 h-4 flex-shrink-0" />
                    {err}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      )}

      {/* Main Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Rules Form */}
        <div className="lg:col-span-2 space-y-6">
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className="card">
              <div className="p-4 border-b border-gray-200">
                <h2 className="text-lg font-semibold text-gray-900">Loan Parameters</h2>
              </div>
              <div className="p-4 space-y-4">
                {fieldConfig.slice(0, 4).map((field) => (
                  <div key={field.name} className="space-y-1">
                    <label className="block text-sm font-medium text-gray-700">
                      {field.label}
                    </label>
                    <input
                      type="number"
                      step={field.step}
                      min={field.name.includes('Rate') || field.name === 'maxLoanToLimitRatio' ? 0 : 1}
                      {...register(field.name, { onChange })}
                      className={clsx('input-field', errors[field.name] && 'border-red-300 focus:ring-red-500 focus:border-red-500')}
                    />
                    {errors[field.name] && (
                      <p className="text-sm text-red-600">{errors[field.name]?.message}</p>
                    )}
                  </div>
                ))}
              </div>
            </div>

            <div className="card">
              <div className="p-4 border-b border-gray-200">
                <h2 className="text-lg font-semibold text-gray-900">Pricing & Fees</h2>
              </div>
              <div className="p-4 space-y-4">
                {fieldConfig.slice(4, 7).map((field) => (
                  <div key={field.name} className="space-y-1">
                    <label className="block text-sm font-medium text-gray-700">
                      {field.label}
                    </label>
                    <input
                      type="number"
                      step={field.step}
                      min={0}
                      max={field.name === 'interestRate' ? 100 : field.name === 'processingFeeRate' ? 50 : 10}
                      {...register(field.name, { onChange })}
                      className={clsx('input-field', errors[field.name] && 'border-red-300 focus:ring-red-500 focus:border-red-500')}
                    />
                    {errors[field.name] && (
                      <p className="text-sm text-red-600">{errors[field.name]?.message}</p>
                    )}
                  </div>
                ))}
              </div>
            </div>

            <div className="card">
              <div className="p-4 border-b border-gray-200">
                <h2 className="text-lg font-semibold text-gray-900">Risk Controls</h2>
              </div>
              <div className="p-4 space-y-4">
                {fieldConfig.slice(7).map((field) => (
                  <div key={field.name} className="space-y-1">
                    <label className="block text-sm font-medium text-gray-700">
                      {field.label}
                    </label>
                    <input
                      type="number"
                      step={field.step}
                      min={field.name === 'maxLoanToLimitRatio' ? 0.1 : 0}
                      max={field.name === 'maxLoanToLimitRatio' ? 1 : field.name === 'minCreditScore' ? 1000 : 10}
                      {...register(field.name, { onChange })}
                      className={clsx('input-field', errors[field.name] && 'border-red-300 focus:ring-red-500 focus:border-red-500')}
                    />
                    {errors[field.name] && (
                      <p className="text-sm text-red-600">{errors[field.name]?.message}</p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </form>
        </div>

        {/* Preview Calculator */}
        <div className="space-y-6">
          <div className="card p-6 sticky top-24">
            <h2 className="text-lg font-semibold text-gray-900 mb-6">Live Preview Calculator</h2>
            
            <div className="space-y-4 mb-6 p-4 bg-gray-50 rounded-lg">
              <h3 className="font-medium text-gray-900">Example Loan: KES 10,000 / 30 days</h3>
              <div className="space-y-3 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Principal</span>
                  <span className="font-medium">KES 10,000</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Interest ({values.interestRate}% p.a.)</span>
                  <span className="font-medium">KES {interest.toLocaleString()}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Processing Fee ({values.processingFeeRate}%)</span>
                  <span className="font-medium">KES {fees.toLocaleString()}</span>
                </div>
                <div className="flex justify-between pt-2 border-t border-gray-200">
                  <span className="font-semibold">Total Repayment</span>
                  <span className="font-bold text-primary-700">KES {totalPayable.toLocaleString()}</span>
                </div>
                <div className="flex justify-between text-xs text-gray-500">
                  <span>APR (approx)</span>
                  <span>{((totalPayable - exampleAmount) / exampleAmount) * (365 / exampleTerm) * 100}%</span>
                </div>
              </div>
            </div>

            {/* Quick validation checks */}
            <div className="space-y-2">
              {validationRules.map((rule, i) => {
                let pass = true;
                if (rule.field === 'minLoanAmount < maxLoanAmount') pass = values.minLoanAmount < values.maxLoanAmount;
                if (rule.field === 'minTermDays < maxTermDays') pass = values.minTermDays < values.maxTermDays;
                if (rule.field === 'interestRate > 0') pass = values.interestRate > 0;
                if (rule.field === 'processingFeeRate >= 0') pass = values.processingFeeRate >= 0;
                if (rule.field === 'lateFeeRate > 0') pass = values.lateFeeRate > 0;
                if (rule.field === 'maxLoanToLimitRatio <= 1') pass = values.maxLoanToLimitRatio <= 1;
                
                return (
                  <div key={i} className="flex items-center gap-2 text-sm">
                    {pass ? (
                      <CheckCircle className="w-4 h-4 text-green-500" />
                    ) : (
                      <XCircle className="w-4 h-4 text-red-500" />
                    )}
                    <span className={pass ? 'text-gray-600' : 'text-red-600'}>
                      {rule.message}
                    </span>
                  </div>
                );
              })}
            </div>

            {/* Impact indicators */}
            <div className="mt-6 p-4 bg-blue-50 rounded-lg">
              <h4 className="font-medium text-blue-900 mb-3">Impact Summary</h4>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-blue-700">Max loan per customer</span>
                  <span className="font-medium">KES {values.maxLoanAmount.toLocaleString()}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-blue-700">Min credit score required</span>
                  <span className="font-medium">{values.minCreditScore}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-blue-700">Max concurrent loans</span>
                  <span className="font-medium">{values.maxActiveLoans}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-blue-700">Max loan as % of limit</span>
                  <span className="font-medium">{(values.maxLoanToLimitRatio * 100).toFixed(0)}%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}