import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Plus, Save, Trash2, Image, Upload } from "lucide-react";
import { useState } from "react";

export default function AddQuestions() {
  const [options, setOptions] = useState([
    { id: 1, text: "", isCorrect: false },
    { id: 2, text: "", isCorrect: false },
    { id: 3, text: "", isCorrect: false },
    { id: 4, text: "", isCorrect: false },
  ]);

  return (
    <AppLayout>
      <PageHeader
        title="Add Questions"
        description="Add questions to question bank"
        breadcrumbs={[
          { label: "Online Exam", href: "/online-exam/create" },
          { label: "Add Questions" },
        ]}
        actions={
          <Button variant="outline" className="gap-2">
            <Upload className="h-4 w-4" />
            Bulk Import
          </Button>
        }
      />

      <Tabs defaultValue="mcq" className="space-y-6">
        <TabsList className="grid w-full grid-cols-4 lg:w-[500px]">
          <TabsTrigger value="mcq">MCQ</TabsTrigger>
          <TabsTrigger value="true-false">True/False</TabsTrigger>
          <TabsTrigger value="short">Short Answer</TabsTrigger>
          <TabsTrigger value="long">Long Answer</TabsTrigger>
        </TabsList>

        <TabsContent value="mcq">
          <div className="grid gap-6 lg:grid-cols-3">
            <div className="lg:col-span-2 space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Question Details</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid gap-4 md:grid-cols-2">
                    <div className="space-y-2">
                      <Label>Subject *</Label>
                      <Select>
                        <SelectTrigger>
                          <SelectValue placeholder="Select subject" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="math">Mathematics</SelectItem>
                          <SelectItem value="physics">Physics</SelectItem>
                          <SelectItem value="chemistry">Chemistry</SelectItem>
                          <SelectItem value="english">English</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="space-y-2">
                      <Label>Topic/Chapter</Label>
                      <Select>
                        <SelectTrigger>
                          <SelectValue placeholder="Select topic" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="algebra">Algebra</SelectItem>
                          <SelectItem value="geometry">Geometry</SelectItem>
                          <SelectItem value="calculus">Calculus</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="question">Question Text *</Label>
                    <Textarea 
                      id="question" 
                      placeholder="Enter your question here..."
                      rows={4}
                    />
                  </div>

                  <div className="flex items-center gap-2">
                    <Button variant="outline" size="sm" className="gap-2">
                      <Image className="h-4 w-4" />
                      Add Image
                    </Button>
                    <span className="text-sm text-muted-foreground">Optional: Add an image to the question</span>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Answer Options</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <RadioGroup defaultValue="1">
                    {options.map((option, index) => (
                      <div key={option.id} className="flex items-center gap-3">
                        <RadioGroupItem value={option.id.toString()} id={`option-${option.id}`} />
                        <div className="flex-1">
                          <Input placeholder={`Option ${String.fromCharCode(65 + index)}`} />
                        </div>
                        <Button variant="ghost" size="icon" className="text-destructive">
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    ))}
                  </RadioGroup>
                  <Button variant="outline" size="sm" className="gap-2">
                    <Plus className="h-4 w-4" />
                    Add Option
                  </Button>
                  <p className="text-sm text-muted-foreground">
                    Select the radio button next to the correct answer
                  </p>
                </CardContent>
              </Card>
            </div>

            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Question Settings</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="space-y-2">
                    <Label>Difficulty Level *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select difficulty" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="easy">Easy</SelectItem>
                        <SelectItem value="medium">Medium</SelectItem>
                        <SelectItem value="hard">Hard</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="marks">Marks *</Label>
                    <Input id="marks" type="number" placeholder="1" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="negativeMarks">Negative Marks</Label>
                    <Input id="negativeMarks" type="number" placeholder="0.25" step="0.25" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="timeLimit">Time Limit (seconds)</Label>
                    <Input id="timeLimit" type="number" placeholder="60" />
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Explanation</CardTitle>
                </CardHeader>
                <CardContent>
                  <Textarea 
                    placeholder="Add explanation for the correct answer (shown after submission)..."
                    rows={4}
                  />
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Actions</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  <Button className="w-full gap-2">
                    <Save className="h-4 w-4" />
                    Save Question
                  </Button>
                  <Button variant="outline" className="w-full gap-2">
                    <Plus className="h-4 w-4" />
                    Save & Add Another
                  </Button>
                </CardContent>
              </Card>
            </div>
          </div>
        </TabsContent>

        <TabsContent value="true-false">
          <Card>
            <CardHeader>
              <CardTitle>True/False Question</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Question Text *</Label>
                <Textarea placeholder="Enter your true/false question..." rows={3} />
              </div>
              <div className="space-y-2">
                <Label>Correct Answer *</Label>
                <RadioGroup defaultValue="true" className="flex gap-6">
                  <div className="flex items-center space-x-2">
                    <RadioGroupItem value="true" id="true" />
                    <Label htmlFor="true" className="font-normal">True</Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <RadioGroupItem value="false" id="false" />
                    <Label htmlFor="false" className="font-normal">False</Label>
                  </div>
                </RadioGroup>
              </div>
              <Button className="gap-2">
                <Save className="h-4 w-4" />
                Save Question
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="short">
          <Card>
            <CardHeader>
              <CardTitle>Short Answer Question</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Question Text *</Label>
                <Textarea placeholder="Enter your short answer question..." rows={3} />
              </div>
              <div className="space-y-2">
                <Label>Expected Answer (Keywords)</Label>
                <Input placeholder="Enter keywords separated by commas" />
              </div>
              <div className="space-y-2">
                <Label>Word Limit</Label>
                <Input type="number" placeholder="50" />
              </div>
              <Button className="gap-2">
                <Save className="h-4 w-4" />
                Save Question
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="long">
          <Card>
            <CardHeader>
              <CardTitle>Long Answer Question</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Question Text *</Label>
                <Textarea placeholder="Enter your long answer question..." rows={4} />
              </div>
              <div className="space-y-2">
                <Label>Model Answer</Label>
                <Textarea placeholder="Enter the model answer for reference..." rows={4} />
              </div>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label>Minimum Words</Label>
                  <Input type="number" placeholder="100" />
                </div>
                <div className="space-y-2">
                  <Label>Maximum Words</Label>
                  <Input type="number" placeholder="500" />
                </div>
              </div>
              <Button className="gap-2">
                <Save className="h-4 w-4" />
                Save Question
              </Button>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </AppLayout>
  );
}
