package com.elearning.dao;

import com.elearning.model.Assignment;
import com.elearning.model.Submission;
import com.elearning.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAO {

    public boolean addAssignment(Assignment assignment) {
        String sql = "INSERT INTO assignments (course_id, title, description, due_date) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assignment.getCourseId());
            ps.setString(2, assignment.getTitle());
            ps.setString(3, assignment.getDescription());
            ps.setDate(4, assignment.getDueDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Assignment> getAllAssignments() {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.*, c.title as course_title FROM assignments a JOIN courses c ON a.course_id = c.id ORDER BY a.due_date ASC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setCourseId(rs.getInt("course_id"));
                a.setCourseTitle(rs.getString("course_title"));
                a.setTitle(rs.getString("title"));
                a.setDescription(rs.getString("description"));
                a.setDueDate(rs.getDate("due_date"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Assignment> getAssignmentsForStudent(int studentId) {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.*, c.title as course_title FROM assignments a JOIN courses c ON a.course_id = c.id JOIN enrollments e ON c.id = e.course_id WHERE e.student_id = ? ORDER BY a.due_date ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setCourseId(rs.getInt("course_id"));
                a.setCourseTitle(rs.getString("course_title"));
                a.setTitle(rs.getString("title"));
                a.setDescription(rs.getString("description"));
                a.setDueDate(rs.getDate("due_date"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean submitAssignment(int assignmentId, int studentId, String fileUrl, String publicId) {
        String sql = "INSERT INTO submissions (assignment_id, student_id, file_url, cloudinary_public_id) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);
            ps.setString(3, fileUrl);
            ps.setString(4, publicId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Submission> getAllSubmissions() {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name as student_name, a.title as assignment_title FROM submissions s JOIN users u ON s.student_id = u.id JOIN assignments a ON s.assignment_id = a.id ORDER BY s.submitted_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Submission sub = new Submission();
                sub.setId(rs.getInt("id"));
                sub.setAssignmentId(rs.getInt("assignment_id"));
                sub.setAssignmentTitle(rs.getString("assignment_title"));
                sub.setStudentId(rs.getInt("student_id"));
                sub.setStudentName(rs.getString("student_name"));
                sub.setFileUrl(rs.getString("file_url"));
                sub.setGrade(rs.getString("grade"));
                sub.setFeedback(rs.getString("feedback"));
                sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                list.add(sub);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Submission> getSubmissionsForStudent(int studentId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, a.title as assignment_title FROM submissions s JOIN assignments a ON s.assignment_id = a.id WHERE s.student_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Submission sub = new Submission();
                sub.setId(rs.getInt("id"));
                sub.setAssignmentTitle(rs.getString("assignment_title"));
                sub.setFileUrl(rs.getString("file_url"));
                sub.setGrade(rs.getString("grade"));
                sub.setFeedback(rs.getString("feedback"));
                sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                list.add(sub);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean gradeSubmission(int submissionId, String grade, String feedback) {
        String sql = "UPDATE submissions SET grade = ?, feedback = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, grade);
            ps.setString(2, feedback);
            ps.setInt(3, submissionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalSubmissions() {
        String sql = "SELECT COUNT(*) FROM submissions";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}