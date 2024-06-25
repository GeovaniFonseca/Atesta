// lib/features/calendar/views/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:hello_world/features/consultas/views/consulta_detalhes_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../atestado/model/atestado_model.dart';
import '../../atestado/views/atestado_detalhes_screen.dart';
import '../../consultas/model/consulta_model.dart';
import '../../exame/model/exame_model.dart';
import '../../exame/views/exame_detalhes_screen.dart';
import '../../vacina/model/vacina.dart';
import '../../vacina/views/vacina_detalhes_screen.dart';
import '../viewmodels/calendario_viewmodel.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarioScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final calendarViewModel =
        Provider.of<CalendarioViewModel>(context, listen: false);
    await calendarViewModel.loadAllEvents();
    setState(() {
      _events = calendarViewModel.events;
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Calendário de Eventos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color.fromARGB(255, 38, 87, 151),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 87, 151).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay!);
    if (events.isEmpty) {
      return const Center(
        child: Text('Nenhum evento para este dia.'),
      );
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        IconData icon;
        String title;
        String subtitle;

        if (event is AtestadoModel) {
          icon = Icons.assignment;
          title = 'Atestado';
          subtitle = "Médico: ${event.nomeMedico}";
        } else if (event is ConsultaModel) {
          icon = Icons.medical_services;
          title = 'Consulta';
          subtitle = "Descrição: ${event.descricao}";
        } else if (event is Exame) {
          icon = Icons.description;
          title = 'Exame';
          subtitle = "Tipo: ${event.tipo}";
        } else if (event is Vacina) {
          icon = Icons.local_hospital;
          title = 'Vacina';
          subtitle = "Tipo: ${event.tipo}";
        } else {
          icon = Icons.event;
          title = 'Evento';
          subtitle = 'Descrição do evento';
        }

        return Card(
          surfaceTintColor: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 38, 87, 151),
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 87, 151),
              ),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 38, 87, 151)),
            onTap: () {
              if (event is AtestadoModel) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AtestadoDetalheScreen(atestado: event),
                  ),
                );
              } else if (event is ConsultaModel) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ConsultaDetalheScreen(consulta: event),
                  ),
                );
              } else if (event is Exame) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExameDetalhesScreen(exame: event),
                  ),
                );
              } else if (event is Vacina) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VacinaDetalhesScreen(vacina: event),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
