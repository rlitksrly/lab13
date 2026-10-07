import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/my_transaction.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายรับ-รายจ่าย'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, txProvider, child) =>
            txProvider.transactions.isEmpty
                ? const Center(child: Text('ไม่มีรายการ'))
                : ListView.builder(
                    itemCount: txProvider.transactions.length,
                    itemBuilder: (ctx, i) {
                      final tx = txProvider.transactions[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: tx.type == TransactionType.income
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          child: Text(
                            tx.type == TransactionType.income ? 'รับ' : 'จ่าย',
                            style: TextStyle(
                              color: tx.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        title: Text(tx.title),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(tx.date)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${tx.amount.toStringAsFixed(2)} ฿',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: tx.type == TransactionType.income
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                context
                                    .read<TransactionProvider>()
                                    .deleteTransaction(tx.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ทดสอบเพิ่มรายการจ่าย
          context.read<TransactionProvider>().addTransaction(
                'ค่าอาหาร',
                120.0,
                DateTime.now(),
                TransactionType.expense,
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
