import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trace_or/config/theme/app_colors.dart';

class ExpandableComment extends StatelessWidget {
  final dynamic comment;
  final VoidCallback onNavigate;

  const ExpandableComment({
    super.key,
    required this.comment,
    required this.onNavigate,
  });

  String formatDate(Timestamp timeStamp){
    DateTime date = timeStamp.toDate();
    return DateFormat("d 'de' MMMM 'de' y", 'es').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double widthApp = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: (widthApp * 0.025)),
            child: comment is Map ? const Icon(Icons.account_circle) : const Icon(Icons.info),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => {
                if(comment is Map){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['user'],
                            style: const TextStyle(
                              color: AppColors.colorOne,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatDate(comment['datePublish']),
                            style: const TextStyle(
                              fontSize: 12
                            ),
                          )
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Text(comment['comment']),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: const Text("Cerrar")
                        )
                      ],
                    ),
                  )
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(comment is Map)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        comment['user'],
                        style: const TextStyle(
                          color: AppColors.colorOne,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      )
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      comment is Map ? comment['comment'] : comment,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    )
                  ), 
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onNavigate,
          )
        ],
      ),
    );
  }
}