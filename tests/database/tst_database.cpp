/****************************************************************************
 *   Copyright (C) 2011  Instituto Nokia de Tecnologia (INdT)               *
 *                                                                          *
 *   This file may be used under the terms of the GNU Lesser                *
 *   General Public License version 2.1 as published by the Free Software   *
 *   Foundation and appearing in the file LICENSE.LGPL included in the      *
 *   packaging of this file.  Please review the following information to    *
 *   ensure the GNU Lesser General Public License version 2.1 requirements  *
 *   will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.   *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 *   GNU Lesser General Public License for more details.                    *
 ****************************************************************************/

#include <QtTest/QtTest>

#include <QtCore/QCoreApplication>
#include <QtCore/QObject>
#include <QtCore/QDir>
#include <QtSql/QSqlRecord>
#include <QtSql/QSqlError>

#include "DatabaseManager.h"
#include "BookmarkModel.h"

class tst_DataBase : public QObject
{
    Q_OBJECT

public:
    tst_DataBase();
    ~tst_DataBase();

public slots:
    void initTestCase();
    void cleanupTestCase();
    void cleanup();

private slots:
    void initialization();
    void insert();
    void update();

private:
    QByteArray m_XdgDataHome;
};

tst_DataBase::tst_DataBase()
{
}

tst_DataBase::~tst_DataBase()
{
}

void tst_DataBase::initTestCase()
{
    QCoreApplication::setApplicationName(QLatin1String("SnowshoeDataBaseTest"));

    m_XdgDataHome = qgetenv("XDG_DATA_HOME");
    setenv("XDG_DATA_HOME", QDir::tempPath().toLatin1().data(), 1);
}

void tst_DataBase::cleanupTestCase()
{
    QDir databaseDir;
    databaseDir.remove(QSqlDatabase::database().databaseName());

    setenv("XDG_DATA_HOME", m_XdgDataHome.data(), 1);
}

void tst_DataBase::cleanup()
{
    QSqlQueryModel model;
    model.setQuery("DELETE FROM bookmarks");
}

void tst_DataBase::initialization()
{
    QCOMPARE(DatabaseManager::instance(), DatabaseManager::instance());
    QCOMPARE(DatabaseManager::instance()->initialize(), true);
}

void tst_DataBase::insert()
{
    BookmarkModel* bookmarkModel = DatabaseManager::instance()->bookmarkDataBaseModel();
    QSqlRecord record;

    {
        bookmarkModel->insert("Nokia", "http://www.nokia.com");

        record = bookmarkModel->record(0);

        const QString name = record.value("name").toString();
        QCOMPARE(name, QLatin1String("Nokia"));

        const QString url = record.value("url").toString();
        QCOMPARE(url, QLatin1String("http://www.nokia.com"));

        const int date = record.value("dateAdded").toInt();
        QVERIFY(date != 0);
    }
}

void tst_DataBase::update()
{
    BookmarkModel* bookmarkModel = DatabaseManager::instance()->bookmarkDataBaseModel();
    QSqlRecord record;

    bookmarkModel->insert("Google", "http://www.google.com");
    {
        record = bookmarkModel->record(0);

        const int oldDate = record.value("dateAdded").toInt();

        bookmarkModel->update(0, "SEARCH", "http://www.blekko.com");
        QSqlError error = bookmarkModel->lastError();
        QCOMPARE(error.type(), QSqlError::NoError);

        record = bookmarkModel->record(0);

        const QString name = record.value("name").toString();
        QCOMPARE(name, QLatin1String("SEARCH"));

        const QString url = record.value("url").toString();
        QCOMPARE(url, QLatin1String("http://www.blekko.com"));

        const int dateAdded = record.value("dateAdded").toInt();
        QVERIFY(dateAdded != oldDate);
    }
}

QTEST_MAIN(tst_DataBase)
#include "tst_database.moc"
