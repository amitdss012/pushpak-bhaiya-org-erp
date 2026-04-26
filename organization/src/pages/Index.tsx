import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { StatsCard } from "@/components/ui/StatsCard";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import {
  Users,
  GraduationCap,
  CreditCard,
  BookOpen,
  TrendingUp,
  Calendar,
  AlertCircle,
  CheckCircle,
} from "lucide-react";
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
} from "recharts";

const admissionData = [
  { month: "Jan", students: 45 },
  { month: "Feb", students: 52 },
  { month: "Mar", students: 78 },
  { month: "Apr", students: 65 },
  { month: "May", students: 90 },
  { month: "Jun", students: 85 },
];

const feeData = [
  { month: "Jan", collected: 125000, pending: 25000 },
  { month: "Feb", collected: 145000, pending: 35000 },
  { month: "Mar", collected: 180000, pending: 20000 },
  { month: "Apr", collected: 155000, pending: 45000 },
  { month: "May", collected: 200000, pending: 30000 },
  { month: "Jun", collected: 175000, pending: 25000 },
];

const courseDistribution = [
  { name: "Science", value: 35, color: "hsl(var(--chart-1))" },
  { name: "Commerce", value: 25, color: "hsl(var(--chart-2))" },
  { name: "Arts", value: 20, color: "hsl(var(--chart-3))" },
  { name: "Engineering", value: 15, color: "hsl(var(--chart-4))" },
  { name: "Medical", value: 5, color: "hsl(var(--chart-5))" },
];

const recentActivities = [
  { id: 1, action: "New student admitted", student: "John Doe", time: "2 hours ago", type: "admission" },
  { id: 2, action: "Fee payment received", student: "Sarah Smith", time: "3 hours ago", type: "payment" },
  { id: 3, action: "Exam scheduled", student: "Physics Final", time: "5 hours ago", type: "exam" },
  { id: 4, action: "Certificate issued", student: "Mike Johnson", time: "6 hours ago", type: "certificate" },
  { id: 5, action: "Due fee reminder sent", student: "Emily Brown", time: "8 hours ago", type: "reminder" },
];

const upcomingEvents = [
  { id: 1, title: "Mid-term Exams", date: "Jan 25, 2024", type: "exam" },
  { id: 2, title: "Parent-Teacher Meeting", date: "Jan 28, 2024", type: "meeting" },
  { id: 3, title: "Annual Sports Day", date: "Feb 5, 2024", type: "event" },
  { id: 4, title: "Fee Submission Deadline", date: "Feb 10, 2024", type: "deadline" },
];

const Index = () => {
  return (
    <AppLayout>
      <PageHeader
        title="Dashboard"
        description="Welcome back! Here's an overview of your school's performance."
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard
          title="Total Students"
          value="2,847"
          subtitle="Active enrollments"
          icon={GraduationCap}
          trend={{ value: 12, isPositive: true }}
          variant="primary"
        />
        <StatsCard
          title="Total Courses"
          value="48"
          subtitle="Across all batches"
          icon={BookOpen}
          trend={{ value: 8, isPositive: true }}
          variant="info"
        />
        <StatsCard
          title="Fee Collection"
          value="₹9.8L"
          subtitle="This month"
          icon={CreditCard}
          trend={{ value: 5, isPositive: true }}
          variant="success"
        />
        <StatsCard
          title="Due Payments"
          value="₹1.2L"
          subtitle="15 students pending"
          icon={AlertCircle}
          trend={{ value: 3, isPositive: false }}
          variant="warning"
        />
      </div>

      <div className="grid gap-6 lg:grid-cols-3 mb-6">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingUp className="h-5 w-5 text-primary" />
              Admission Trends
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={admissionData}>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                <XAxis dataKey="month" stroke="hsl(var(--muted-foreground))" fontSize={12} />
                <YAxis stroke="hsl(var(--muted-foreground))" fontSize={12} />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "hsl(var(--card))",
                    border: "1px solid hsl(var(--border))",
                    borderRadius: "8px",
                  }}
                />
                <Area
                  type="monotone"
                  dataKey="students"
                  stroke="hsl(var(--primary))"
                  fill="hsl(var(--primary) / 0.2)"
                  strokeWidth={2}
                />
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <BookOpen className="h-5 w-5 text-primary" />
              Course Distribution
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <PieChart>
                <Pie
                  data={courseDistribution}
                  cx="50%"
                  cy="50%"
                  innerRadius={50}
                  outerRadius={80}
                  paddingAngle={2}
                  dataKey="value"
                >
                  {courseDistribution.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip
                  contentStyle={{
                    backgroundColor: "hsl(var(--card))",
                    border: "1px solid hsl(var(--border))",
                    borderRadius: "8px",
                  }}
                />
              </PieChart>
            </ResponsiveContainer>
            <div className="grid grid-cols-2 gap-2 mt-4">
              {courseDistribution.map((item) => (
                <div key={item.name} className="flex items-center gap-2 text-sm">
                  <div
                    className="h-3 w-3 rounded-full"
                    style={{ backgroundColor: item.color }}
                  />
                  <span className="text-muted-foreground">{item.name}</span>
                  <span className="font-medium ml-auto">{item.value}%</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 lg:grid-cols-3 mb-6">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CreditCard className="h-5 w-5 text-primary" />
              Fee Collection Overview
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={feeData}>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                <XAxis dataKey="month" stroke="hsl(var(--muted-foreground))" fontSize={12} />
                <YAxis stroke="hsl(var(--muted-foreground))" fontSize={12} />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "hsl(var(--card))",
                    border: "1px solid hsl(var(--border))",
                    borderRadius: "8px",
                  }}
                  formatter={(value: number) => `₹${(value / 1000).toFixed(0)}K`}
                />
                <Bar dataKey="collected" fill="hsl(var(--chart-2))" radius={[4, 4, 0, 0]} />
                <Bar dataKey="pending" fill="hsl(var(--chart-3))" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
            <div className="flex items-center justify-center gap-6 mt-4">
              <div className="flex items-center gap-2">
                <div className="h-3 w-3 rounded-full bg-chart-2" />
                <span className="text-sm text-muted-foreground">Collected</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="h-3 w-3 rounded-full bg-chart-3" />
                <span className="text-sm text-muted-foreground">Pending</span>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Calendar className="h-5 w-5 text-primary" />
              Upcoming Events
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {upcomingEvents.map((event) => (
              <div key={event.id} className="flex items-start gap-3 p-3 rounded-lg bg-muted/50">
                <div className="mt-0.5">
                  <Calendar className="h-4 w-4 text-primary" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium truncate">{event.title}</p>
                  <p className="text-xs text-muted-foreground">{event.date}</p>
                </div>
                <Badge variant="secondary" className="text-xs">
                  {event.type}
                </Badge>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Users className="h-5 w-5 text-primary" />
            Recent Activity
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {recentActivities.map((activity) => (
              <div
                key={activity.id}
                className="flex items-center gap-4 p-3 rounded-lg hover:bg-muted/50 transition-colors"
              >
                <Avatar className="h-10 w-10">
                  <AvatarFallback className="bg-primary/10 text-primary">
                    {activity.student.charAt(0)}
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium">{activity.action}</p>
                  <p className="text-xs text-muted-foreground">{activity.student}</p>
                </div>
                <div className="text-right">
                  <Badge
                    variant="secondary"
                    className={
                      activity.type === "payment"
                        ? "bg-success/10 text-success"
                        : activity.type === "reminder"
                        ? "bg-warning/10 text-warning"
                        : ""
                    }
                  >
                    {activity.type === "payment" && <CheckCircle className="h-3 w-3 mr-1" />}
                    {activity.type}
                  </Badge>
                  <p className="text-xs text-muted-foreground mt-1">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </AppLayout>
  );
};

export default Index;
