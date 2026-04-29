import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text("Assignments"),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('assignments')
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No assignments found!",
                style: TextStyle(
                  fontSize:16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,

            itemBuilder: (context,index){

              final item=
              tasks[index].data()
              as Map<String,dynamic>;

              final status=
              item['status'] ?? "Pending";

              bool isPending=
              status.toString().toLowerCase()
              =="pending";

              Color color=
              isPending
              ? const Color(0xFFFC5C7D)
              : const Color(0xFF11998E);

              return Container(
                margin: const EdgeInsets.only(
                  bottom:12,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(16),

                  boxShadow:[
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius:10,
                      offset: const Offset(0,4),
                    )
                  ],
                ),

                child: ListTile(
                  leading: Icon(
                    isPending
                    ? Icons.pending_actions
                    : Icons.check_circle,
                    color: color,
                    size:32,
                  ),

                  title: Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize:15,
                    ),
                  ),

                  subtitle: Text(
                    "${item['subject']} • Due: ${item['due']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  trailing: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal:10,
                      vertical:6,
                    ),

                    decoration: BoxDecoration(
                      color:
                      color.withOpacity(.1),
                      borderRadius:
                      BorderRadius.circular(8),
                    ),

                    child: Text(
                      status.toString(),
                      style: TextStyle(
                        color:color,
                        fontWeight:
                        FontWeight.bold,
                        fontSize:12,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}